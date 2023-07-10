
import cv2
import numpy as np
import numba
from tqdm import trange
import numpy

def calc_energy(img, img_dm, img_sm):

    img = img.astype('float32')
    filtered_img = cv2.GaussianBlur(np.uint8(img), (13, 13), 0)

    ##gradient
    grad_x = cv2.Sobel(filtered_img, cv2.CV_64F, 1, 0, ksize=3)
    grad_y = cv2.Sobel(filtered_img, cv2.CV_64F, 0, 1, ksize=3)
    magnitude = np.sqrt(grad_x ** 2 + grad_y ** 2)
    ##normalize gradient
    gr_map = cv2.cvtColor(np.uint8(magnitude), cv2.COLOR_BGR2GRAY)

    ##find edges by canny on Gradient map
    edges = cv2.Canny(np.uint8(gr_map), 20, 100)
    edges = cv2.normalize(edges, None, 0, 255, cv2.NORM_MINMAX)

    gray = cv2.cvtColor(((img_sm)), cv2.COLOR_BGR2GRAY)
    ###blure Saliency image by average kernel
    blur_img_sm = cv2.blur(gray, (71, 71))


    ###intersection between blured depth map and blured saliency map by inner product for finding most important part of image

    # change saliency and depth image to gray
    img_sm = cv2.cvtColor(img_sm, cv2.COLOR_BGR2GRAY)
    img_dm = cv2.cvtColor(img_dm, cv2.COLOR_BGR2GRAY)

    # unused idea

    # inner_dm_sm=(np.int32(blur_img_sm)*np.int32(blur_img_dm))
    # inner_gr_sm = (np.int32(gr_map) * np.int32(blur_img_sm))

    # add two Saliency and Depth map with each other
    SMplusDM = np.int64(blur_img_sm) + np.int64(img_dm)
    SMplusDM = cv2.normalize(SMplusDM, None, 0, 255, cv2.NORM_MINMAX)
    gr_map = cv2.normalize(gr_map, None, 0, 255, cv2.NORM_MINMAX)

    # inner product of (saliency +depth) , Gradient map
    inner_sm_dm_gr = np.int32(SMplusDM) * np.int32(gr_map)
    inner_sm_dm_gr = cv2.normalize(inner_sm_dm_gr, None, 0, 255, cv2.NORM_MINMAX)

    # normalize all part consist energy map between 0 and 1
    img_dm = (img_dm - np.min(img_dm)) / (np.max(img_dm) - np.min(img_dm))
    edges = (edges - np.min(edges)) / (np.max(edges) - np.min(edges))
    inner_sm_dm_gr = (inner_sm_dm_gr - np.min(inner_sm_dm_gr)) / (np.max(inner_sm_dm_gr) - np.min(inner_sm_dm_gr))

    # calculate energy map by add edges , depth map and combination of saliency depth and gradient
    energy_map = (2 * inner_sm_dm_gr + img_dm + edges)

    # this part just for show impact of each part on output energy map



    # show = np.uint8(cv2.normalize(img_dm, None, 0, 255, cv2.NORM_MINMAX))
    # cv2.imshow('img_dm', show)
    # cv2.waitKey(0)
    #
    # show = np.uint8(cv2.normalize(edges, None, 0, 255, cv2.NORM_MINMAX))
    # cv2.imshow('edges', show)
    # cv2.waitKey(0)
    #
    # show = np.uint8(cv2.normalize(inner_sm_dm_gr, None, 0, 255, cv2.NORM_MINMAX))
    # cv2.imshow('inner_sm_dm_gr', show)
    # cv2.waitKey(0)
    #
    # show = np.uint8(cv2.normalize(energy_map, None, 0, 255, cv2.NORM_MINMAX))
    # cv2.imshow('energy_map', show)
    # cv2.waitKey(0)
    #
    # cv2.destroyAllWindows()

    return energy_map


def crop_c(img, scale_c, img_dm, img_sm):
    r, c, _ = img.shape
    new_c = int(scale_c * c)

    for i in trange(c - new_c):
        img, img_dm, img_sm = carve_column(img, img_dm, img_sm)

    return img, img_dm, img_sm


def crop_r(img, scale_r, img_dm, img_sm):
    img = np.rot90(img, 1, (0, 1))
    img_dm = np.rot90(img_dm, 1, (0, 1))
    img_sm = np.rot90(img_sm, 1, (0, 1))
    img, img_dm, img_sm = crop_c(img, scale_r, img_dm, img_sm)
    img = np.rot90(img, 3, (0, 1))
    img_dm = np.rot90(img_dm, 3, (0, 1))
    img_sm = np.rot90(img_sm, 3, (0, 1))
    return img, img_dm, img_sm


# for accelerate speed
@numba.jit
def carve_column(img, img_dm, img_sm):
    r, c, _ = img.shape

    M, backtrack = minimum_seam(img, img_dm, img_sm)
    mask = np.ones((r, c), dtype=bool)

    j = np.argmin(M[-1])
    for i in reversed(range(r)):
        mask[i, j] = False
        j = backtrack[i, j]

    mask = np.stack([mask] * 3, axis=2)
    img = img[mask].reshape((r, c - 1, 3))
    img_dm = img_dm[mask].reshape((r, c - 1, 3))
    img_sm = img_sm[mask].reshape((r, c - 1, 3))
    return img, img_dm, img_sm


@numba.jit
# I change it to use a 15 neighbor because of image with have many important object in it

def minimum_seam(img, img_dm, img_sm):
    r, c, _ = img.shape
    energy_map = calc_energy(img, img_dm, img_sm)

    M = energy_map.copy()
    backtrack = np.zeros_like(M, dtype=int)

    for i in range(1, r):
        for j in range(0, c):
            # Handle the left edge of the image, to ensure we don't index a -1
            if j == 0 or j == 1:

                idx = np.argmin(M[i - 1, j:j + 3])
                backtrack[i, j] = idx + j
                min_energy = M[i - 1, idx + j]

            elif j == c - 1 or j == c - 2 or j == c - 3:

                idx = np.argmin(M[i - 1, j - 2:j + 1])
                backtrack[i, j] = idx + j - 2
                min_energy = M[i - 1, idx + j]

            else:
                idx = np.argmin(M[i - 1, j - 2:j + 3])
                backtrack[i, j] = idx + j - 1
                min_energy = M[i - 1, idx + j - 1]

            M[i, j] += min_energy

    return M, backtrack


def main():
    width = int(input("widht: "))
    height = int(input("height: "))
    in_filename = input("Input filename:")
    in_filename_dm = input("Input depth filename:")
    in_filename_sm = input("Input saliency filename:")
    out_filename = input("Output filename: ")

    img = cv2.imread(in_filename)
    img_sm = cv2.imread(in_filename_sm)
    img_dm = cv2.imread(in_filename_dm)

    scale = height / (img.shape[0])
    out, out_dm, out_sm = crop_r(img, scale, img_dm, img_sm)
    scale = width / (img.shape[1])
    out, out_dm, out_sm = crop_c(out, scale, out_dm, out_sm)

    show = np.uint8(cv2.normalize(out, None, 0, 255, cv2.NORM_MINMAX))
    cv2.imshow('final output', show)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    cv2.imwrite(out_filename, out)
    cv2.imwrite("dm_" + out_filename, out_dm)
    cv2.imwrite("sm_" + out_filename, out_sm)


if __name__ == '__main__':
    main()



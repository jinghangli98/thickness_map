import torchio as tio
import numpy as np
import nibabel as nib
import ants
import glob
from natsort import natsorted
from tqdm import tqdm
import pdb
import sys

template = '/ix1/tibrahim/jil202/07-Myelin_mapping/mni_icbm152_nlin_asym_09a/mni_icbm152_t1_tal_nlin_asym_09a.nii'
template = ants.image_read(template)
image_input = sys.argv[1]
output = sys.argv[2]

mi = ants.image_read(image_input)
mytx = ants.registration(fixed=template, moving=mi, type_of_transform = 'Rigid' )
ants.image_write(mytx['warpedmovout'], output)
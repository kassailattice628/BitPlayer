# read_from_bf
"""
Set
"""
from .bioform_2_txt import bioform_2_txt
from .extract_params import extract_params6
from .save_2_mat import save_2_mat

def read_from_bf(save_dir, data_path):
    """
    Read from BF -> Txt -> MAT
    """
    #Read BioFromat MetaData and Save as text
    bioform_2_txt(save_dir, data_path)

    #Read and Extract MetaData
    params = extract_params6(save_dir)

    #Save as Mat file
    save_2_mat(params, save_dir)

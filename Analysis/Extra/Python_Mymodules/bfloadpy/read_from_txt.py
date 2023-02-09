"""
Read Metadata from txt.
Extract params as mat
"""
from .extract_params import extract_params6
from .save_2_mat import save_2_mat

def read_from_txt(save_dir):
    """
    Read Metadata from txt.
    Extract params as mat
    """
    params = extract_params6(save_dir)
    save_2_mat(params, save_dir)

    return 1

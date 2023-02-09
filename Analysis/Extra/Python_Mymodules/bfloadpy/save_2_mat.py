#save_2_mat
"""
Save params as matfile
"""

import scipy.io

def save_2_mat(params, savedir):
    """
    save as mat
    """
    savepath_mat = savedir + 'bfmeta.mat'
    scipy.io.savemat(savepath_mat, {'MetaData':params})

    return 1

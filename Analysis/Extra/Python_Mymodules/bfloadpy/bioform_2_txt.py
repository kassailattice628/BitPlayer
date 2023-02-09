#bioform_2_txt
"""
    Read metadata from bioformat microscope data,
    Save as txt file.
"""

import os

def bioform_2_txt(savedir, datapath):
    """
    Read bioformat metadata and save as txt
    """
    print('RUN PYTHON BIOFORM_2_TXT')
    sp = os.path.splitext(savedir)
    
    if sp[1] == '.oif' or sp[1] == '.oib':
        print('Reading olympus metadata1')
        fname = '_bfmeta.txt'
        savepath = sp[0] + fname
    elif sp[1] == '':
        print('Reading olympus metadata2')
        fname = 'bfmeta.txt'
        savepath = sp[0] + fname
    else:
        print('Reading txt formast olympus metadata')
        #sp[1] == '.txt':
        savepath = savedir
    
    print(datapath)
    print(savepath)
    os.system("/home/lattice/Share/Ana_ver11_AppDesigner/extra/bftools/showinf -nopix %s > '%s'" % (datapath, savepath))
    print('Running showinf -> saved as txt')

    return 1
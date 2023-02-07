#Extract_params
"""
Extract 6 () params from metadata
"""
import os
import pandas as pd
import re

def read_meta_txt(savedir):
    """Read txt metadata file
    Make dataframe for parameters
    """
    sp = os.path.splitext(savedir)
    if not sp[1]:
        fname = '_bfmeta.txt'
        print(fname)
        savepath = sp[0] + fname
    else:
        savepath = savedir

    print(1)
    #Read from text file
    with open(savepath) as f:
        lines = f.readlines()

    #Remove
    lines_strip = [line.strip() for line in lines]
    df = pd.Series(lines_strip)
    df = df.str.split(': ', expand=True)
    if df.shape[1] == 3:
        df.columns = ['key', 'value', 'extra']
    elif df.shape[1] == 2:
        df.columns = ['key', 'value']

    return df


def extract_any(savedir, keylist):
    """Extract
    specified params
    """

    df = read_meta_txt(savedir)

    params = []
    for i_key in keylist:
         p = df[df['key'] == i_key]['value']
         params.append(float(p))

    return params

def extract_params6(savedir):
    """Extract
    objective power
    x (um) for imaging area (not actual)
    y (um) for imaging area (not actual)
    x (pix) image size
    y (pix) image size
    time per frame (us)
    """

    df = read_meta_txt(savedir)

    #Get Parames
    obj_mag = df[df['key'] == 'Magnification']['value']
    x_um = df[df['key'] == '[Axis 0 Parameters Common] EndPosition']['value']
    y_um = df[df['key'] == '[Axis 1 Parameters Common] EndPosition']['value']
    x_pix = df[df['key'] == '[Axis 0 Parameters Common] MaxSize']['value']
    y_pix = df[df['key'] == '[Axis 1 Parameters Common] MaxSize']['value']
    time_per_frame = df[df['key'] == 'Time Per Frame']['value']

    params = [float(obj_mag), float(x_um.values), float(y_um.values), float(x_pix.values), float(y_pix.values), float(time_per_frame.values)]

    return params

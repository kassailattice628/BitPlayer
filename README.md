# BitPlayer

Last Update 2023/02/01

***
BitPlayer is the Matlab app for
1. Recoding with DAQ (NI DAQ device) 
1. Video Recording (Point Gray USB Cam) with IMAQ
1. Visual stimuli with PTB3.
---

## Requirements
- Matlab R2022a
    - GUIs were created using appdesigner
- Two PCs (Windows and Linux)

### DAQ
- Windows PC (Windows 11)
- Matlab R2022a
    - DAQ toolbox
    - IMAQ toolbox
    - Image Acquisition Toolbox Support Package for Point Grey Hardware
- NI DAQ (USB 6341 (BNC))
- USB3 Camera, [FLIR Grasshopper3 USB](https://www.flir.jp/products/grasshopper3-usb3/?model=GS3-U3-23S6M-C&vertical=machine+vision&segment=iis)
- [iRecHS2](https://staff.aist.go.jp/k.matsuda/iRecHS2/index_j.html) software (by Dr. Matsuda)
    - Grasshopper3
    - [Contec DAC 1604L-LPF](https://www.contec.com/jp/products-services/daq-control/pc-helper/pcie-card/ao-1604l-lpe/specification/)
        - 端子台
        - ケーブル

### PTB
- Ubuntu 22.04.5 LTS (2022/1/12)
- Matlab R2022a
    - Psychtoolbox3 -> [Install for Linux](http://psychtoolbox.org/download#Linux)
- USB to Serial (RS232) conversion device, [sample1](https://www.amazon.co.jp/gp/product/B00QUZY4UG/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1), [sample2](https://www.amazon.co.jp/dp/B07BBPX8B8/ref=redir_mobile_desktop?_encoding=UTF8&aaxitk=b4562da571740fa03e0eaec0f085e3e6&content-id=amzn1.sym.74628ee6-91f7-498f-9ee3-48ebe7802b64%3Aamzn1.sym.74628ee6-91f7-498f-9ee3-48ebe7802b64&hsa_cr_id=1826034210703&pd_rd_plhdr=t&pd_rd_r=21858199-a496-4344-984a-a2421f3c8821&pd_rd_w=iBz1R&pd_rd_wg=KwAnd&qid=1673485061&ref_=sbx_be_s_sparkle_mcd_asin_1_img&sr=1-2-ac08f2b1-eb5b-4f1a-aa64-9e8f448c33ed)
___
## Visual Stimulation using PTB3
1. Simple spot 
1. Fine mapping
1. Random Size
1. Moving Bar
1. Static Bar
1. Moving Spot
1. Sinusoidal, Shifting Grating, Gabor
1. Image (under development)
1. Mosaic (under development)
1. 2points, black/white (under development)
___
## DAQ channel configureation (see daq_ini)
1. Recording Eye positino singal from iRecHS2 (anohter WindowsPC)
    1. AI0: Pupil Horizontal movement
    1. AI1: Pupil Verticac movement
    1. AI2: Photo sensor
    1. AI3: **** Used for trigger monitor
    1. AI4: Pupil Size (not good)
1. Video recording of Eye camera (500Hz)
1. Recoding locomotion (Rotary encoder)

***
## Change history

2022/01/31
* Change settings of the capturing video from uncompress AVI to motion jpeg AVI.

2022/02/01
* Correct Movie setting.
* Check next number of save-directory.
* Need to repair DAQ save function: SaveData & SaveTimestamps does not save 1st loop...
***




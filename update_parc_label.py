#!/usr/bin/env python3

import json
import numpy as np
import nibabel as nib

def load_parc_data(parc_path):

	return nib.load(parc_path)

def read_label_json(label_path):

	with open(label_path,'r') as lf:
		label = json.load(lf)
	return label

def output_parc_data(parc,outpath):

	nib.save(parc,outpath)

def update_parc(data,label_dict,parc_outpath):
	
	unique_voxels = [ f['voxel_value'] for f in label_dict ]
	unique_labels = [ f['label'] for f in label_dict ]

        new_data = data.get_fdata()
	for i in range(len(unique_labels)):
		new_data[np.where(new_data == unique_labels[i])] = unique_voxels[i]
        out_data = nib.Nifti1Image(new_data,data.affine,data.header)
	output_parc_data(out_data,parc_outpath)

def main():

	with open('config.json','r') as config_f:
		config = json.load(config_f)

	dtype = config['type']

	if dtype == "thal":
		parc_dir = ['./thal_parc/']
		parc_path = [parc_dir[0]+'/parc.nii.gz']
		label_path = [parc_dir[0]+'/label.json']
	elif dtype == "hippamyg":
		parc_dir = ['./hippamyg_parc/']
		parc_path = [parc_dir[0]+'/parc.nii.gz']
		label_path = [parc_dir[0]+'/label.json']
	else:
		parc_dir = ['./thal_parc/','./hippamyg_parc/']
		parc_path = [parc_dir[0]+'/parc.nii.gz',parc_dir[1]+'/parc.nii.gz']
		label_path = [parc_dir[0]+'/label.json',parc_dir[1]+'/label.json']
	
	for i in range(len(parc_path)):
		data = load_parc_data(parc_path[i])
		label = read_label_json(label_path[i])
		outpath = parc_dir[i]
		update_parc(data,label,outpath+'/parc2.nii.gz')

if __name__ == '__main__':
	main()

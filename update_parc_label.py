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

def output_label_json(labels,outpath):

	with open(outpath,'w') as lf:
		json.dump(labels,outpath)

def identify_unique_labels(data,label_dict):

	unique_labels = np.unique(data[data > 0])
	return [ f for f in label_dict if f['voxel_value'] in unique_labels ]

def update_label(data,label_dict,outpath):

	labels = identify_unique_labels(data,label_dict)
	
	for i in range(len(labels)):
		labels[i]['voxel_value'] = i+1

	output_label_json(labels,outpath)

	return labels

def update_parc(data,label_dict,label_outpath,parc_outpath)
	
	labels = update_label(data,label_dict,label_outpath)
	unique_voxels = [ f['voxel_value'] for f in labels ]
	unique_labels = [ int(f['label']) for f in labels]
	
	for i in range(len(unique_labels)):
		data[np.where(data == unique_labels[i])] = unique_voxels[i]

	output_parc_data(data,parc_outpath)

def main():

	with open('config.json','r') as config_f:
		config = json.load(config_f)

	parc_type = config['type']

	if type == "thal":
		parc_dir = ['./thal_parc/']
		parc_path = [parc_dir[0]+'/parc.nii.gz']
		label_path = [parc_dir[0]+'/label.json']
	elif type == "hippamyg":
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
		update_parc(data,label,outpath+'/label.json',outpath+'/parc.nii.gz')
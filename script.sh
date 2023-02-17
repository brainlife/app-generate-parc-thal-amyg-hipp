#!/bin/bash

freesurfer=`jq -r '.freesurfer' config.json`
t1=`jq -r '.t1' config.json`

hipp_amyg="hippoAmygLabels-T1.v*.FSvoxelSpace"
thal="ThalamicNuclei.v*.T1.FSvoxelSpace"

thal_parc="thal_parc"
hippamyg_parc="hippamyg_parc"

[ ! -d ${thal_parc} ] && mkdir ${thal_parc}
[ ! -d ${hippamyg_parc} ] && mkdir ${hippamyg_parc}


if [ -f ${freesurfer}/mri/${thal}.mgz ]; then
	[ ! -f ${thal_parc}/parc.nii.gz ] && mri_convert ${freesurfer}/mri/${thal}.mgz ./thal.nii.gz && mri_vol2vol --mov ./thal.nii.gz --targ ${t1} --regheader --interp nearest --o ${thal_parc}/parc.nii.gz --force
fi

if [ -f ${freesurfer}/mri/lh.${hipp_amyg}.mgz ] && [ -f ${freesurfer}/mri/rh.${hipp_amyg}.mgz ]; then
	[ ! -f ${hippamyg_parc}/parc.nii.gz ] && mri_convert ${freesurfer}/mri/lh.${hipp_amyg}.mgz ./lh.hippamyg.nii.gz && mri_convert ${freesurfer}/mri/rh.${hipp_amyg}.mgz ./rh.hippamyg.nii.gz && fslmaths ./rh.hippamyg.nii.gz -add 100 ./rh.hippamyg.nii.gz && fslmaths ./lh.hippamyg.nii.gz -add rh.hippamyg.nii.gz ./hippamyg.nii.gz && mri_vol2vol --mov ./hippamyg.nii.gz --targ ${t1} --regheader --interp nearest --o ${hippamyg_parc}/parc.nii.gz --force
fi
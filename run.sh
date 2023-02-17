#!/bin/bash

freesurfer=`jq -r '.freesurfer' config.json`
t1=`jq -r '.t1' config.json`
subdivision=`jq -r '.subdivision' config.json`
type=`jq -r '.type' config.json`

if [[ ${type} == "thal" ]]; then
	thal="ThalamicNuclei.v*.T1.FSvoxelSpace"
	thal_outjson="thal_label.json"
	thal_outdir="thal_outdir"
elif [[ ${type} == "hippamyg" ]]; then
	if [[ ${subdivision} == "default" ]]; then
		hipp_amyg="hippoAmygLabels-T1.v*.FSvoxelSpace"
	else
		hipp_amyg="hippoAmygLabels-T1.v*.${subdivision}.FSvoxelSpace"
	fi
	hippamyg_outdir="hippamyg_outdir"
	hippamyg_outjson="hippamyg_label.json"
else
	thal_outdir="thal_outdir"
	hippamyg_outdir="hippamyg_outdir"
	thal_outjson="thal_label.json"
	hippamyg_outjson="hippamyg_label.json"

	thal="ThalamicNuclei.v*.T1.FSvoxelSpace"

	if [[ ${subdivision} == "default" ]]; then
		hipp_amyg="hippoAmygLabels-T1.v*.FSvoxelSpace"
	else
		hipp_amyg="hippoAmygLabels-T1.v*.${subdivision}.FSvoxelSpace"
	fi
fi

if [[ ${type} == "thal" ]]; then
	[ ! -f ${thal_outdir}/parc.nii.gz ] && mri_convert ${freesurfer}/mri/${thal}.mgz ./thal.nii.gz && mri_vol2vol --mov ./thal.nii.gz --targ ${t1} --regheader --interp nearest --o ${thal_outdir}/parc.nii.gz --force

	[ ! -f ${thal_outdir}/label.json ] && cp ${thal_outjson} ${thal_outdir}/label.json

	if [ ! -f ${thal_outdir}/parc.nii.gz ] || [ ! -f ${thal_outdir}/label.json ]; then
		echo "something went wrong. check derivatives and logs"
		exit 1
	else
		echo "complete"
		exit 0
	fi
elif [[ ${type} == "hippamyg" ]]; then
	[ ! -f ${hippamyg_outdir}/parc.nii.gz ] && mri_convert ${freesurfer}/mri/lh.${hipp_amyg}.mgz ./lh.hippamyg.nii.gz && mri_convert ${freesurfer}/mri/rh.${hipp_amyg}.mgz ./rh.hippamyg.nii.gz && fslmaths ./rh.hippamyg.nii.gz -add 100 ./rh.hippamyg.nii.gz && fslmaths ./rh.hippamyg.nii.gz -thr 200 ./rh.hippamyg.nii.gz && fslmaths ./lh.hippamyg.nii.gz -add rh.hippamyg.nii.gz ./hippamyg.nii.gz && mri_vol2vol --mov ./hippamyg.nii.gz --targ ${t1} --regheader --interp nearest --o ${hippamyg_outdir}/parc.nii.gz --force
	
	[ ! -f ${hippamyg_outdir}/label.json ] && cp ${hipp_outjson} ${hippamyg_outdir}/label.json

	if [ ! -f ${hippamyg_outdir}/parc.nii.gz ] || [ ! -f ${hippamyg_outdir}/label.json ]; then
		echo "something went wrong. check derivatives and logs"
		exit 1
	else
		echo "complete"
		exit 0
	fi
else
	[ ! -f ${thal_outdir}/parc.nii.gz ] && mri_convert ${freesurfer}/mri/${thal}.mgz ./thal.nii.gz && mri_vol2vol --mov ./thal.nii.gz --targ ${t1} --regheader --interp nearest --o ${thal_outdir}/parc.nii.gz --force
	[ ! -f ${hippamyg_outdir}/parc.nii.gz ] && mri_convert ${freesurfer}/mri/lh.${hipp_amyg}.mgz ./lh.hippamyg.nii.gz && mri_convert ${freesurfer}/mri/rh.${hipp_amyg}.mgz ./rh.hippamyg.nii.gz && fslmaths ./rh.hippamyg.nii.gz -add 100 ./rh.hippamyg.nii.gz && fslmaths ./rh.hippamyg.nii.gz -thr 200 ./rh.hippamyg.nii.gz && fslmaths ./lh.hippamyg.nii.gz -add rh.hippamyg.nii.gz ./hippamyg.nii.gz && mri_vol2vol --mov ./hippamyg.nii.gz --targ ${t1} --regheader --interp nearest --o ${hippamyg_outdir}/parc.nii.gz --force

	[ ! -f ${hippamyg_outdir}/label.json ] && cp ${hipp_outjson} ${hippamyg_outdir}/label.json
	[ ! -f ${thal_outdir}/label.json ] && cp ${thal_outjson} ${thal_outdir}/label.json
	
	if [ ! -f ${thal_outdir}/parc.nii.gz ] || [ ! -f ${thal_outdir}/label.json ] || [ ! -f ${hippamyg_outdir}/parc.nii.gz ] || [ ! -f ${hippamyg_outdir}/label.json ]; then
		echo "something went wrong. check derivatives and logs"
		exit 1
	else
		echo "complete"
		exit 0
	fi
fi

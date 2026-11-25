<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Converts FreeSurfer thalamic nuclei and hippocampal/amygdala segmentations into two volumetric parcellations in T1 space, each with a label.json.**

Converts the thalamic nuclei and the left/right hippoAmygLabels files with mri_convert (right-hemisphere hippocampal labels offset by 100), resamples them to the T1 grid with mri_vol2vol (nearest neighbour), and renumbers voxel values with bundled label tables. Run both FreeSurfer thalamic nuclei and hippocampal subfield segmentations first.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.734](https://doi.org/10.25663/brainlife.app.734)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `freesurfer` | `neuro/freesurfer` (thalamic_nuclei, hippocampal) | yes | FreeSurfer subject directory (FreeSurfer 7) containing the thalamic nuclei and hippocampal/amygdala segmentation files in mri/. |
| `t1` | `neuro/anat/t1w` | yes | T1-weighted image that defines the output space and voxel grid. Must be in the same space as the FreeSurfer input (resampled with --regheader). |

| Output | Datatype | Description |
|---|---|---|
| `hippamyg_parc` | `neuro/parcellation/volume` | Hippocampal subfield and amygdala nuclei parcellation (parc.nii.gz) on the T1 grid with label.json. |
| `thal_parc` | `neuro/parcellation/volume` | Thalamic nuclei parcellation (parc.nii.gz) on the T1 grid with label.json. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `type` | enum | `both` | Which FreeSurfer segmentation to convert: thal (thalamic nuclei), hippamyg (hippocampal subfields and amygdala nuclei) or both. Fixed for this App. Options: `thal`, `hippamyg`, `both`. |
| `subdivision` | enum | `default` | Which hippocampal/amygdala segmentation level to use (FreeSurfer hippoAmygLabels files): default (full detail), CA, FS60 or HBT. Ignored for thalamic nuclei. Options: `CA`, `FS60`, `HBT`, `default`. |

Runtime: container `brainlife/connectome_workbench:1.5.0`; 8 CPUs; 1.5 h walltime; needs `FREESURFER_LICENSE`.

<!-- brainlife-app:end -->

# app-generate-parc-thal-amyg-hipp
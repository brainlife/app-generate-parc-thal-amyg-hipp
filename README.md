<h1 align="center">Thalamic, hippocampal and amygdala parcellations</h1>

<p align="center">
  Volumetric parcellations in T1 space, each with a label.json, from FreeSurfer's thalamic nuclei and hippocampal subfield and amygdala segmentations.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.734"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.734-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Converts FreeSurfer thalamic nuclei and hippocampal/amygdala segmentations into two volumetric parcellations in T1 space, each with a label.json.**

Converts the thalamic nuclei and the left/right hippoAmygLabels files with mri_convert (right-hemisphere hippocampal labels offset by 100), resamples them to the T1 grid with mri_vol2vol (nearest neighbour), and renumbers voxel values with bundled label tables. Run both FreeSurfer thalamic nuclei and hippocampal subfield segmentations first.

| | |
|---|---|
| 📥 **Inputs** | `neuro/freesurfer` · `neuro/anat/t1w` |
| 📤 **Outputs** | `neuro/parcellation/volume` ×2 |
| 🐳 **Container** | `brainlife/connectome_workbench:1.5.0` |
| ⚙️ **Resources** | 8 CPUs · 1.5 h walltime |
| 🔑 **Requires** | `FREESURFER_LICENSE` |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.734](https://doi.org/10.25663/brainlife.app.734) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `freesurfer` | `neuro/freesurfer` (thalamic_nuclei, hippocampal) | yes | FreeSurfer subject directory (FreeSurfer 7) containing the thalamic nuclei and hippocampal/amygdala segmentation files in mri/. |
| `t1` | `neuro/anat/t1w` | yes | T1-weighted image that defines the output space and voxel grid. Must be in the same space as the FreeSurfer input (resampled with --regheader). |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `hippamyg_parc` | `neuro/parcellation/volume` | Hippocampal subfield and amygdala nuclei parcellation (parc.nii.gz) on the T1 grid with label.json. |
| `thal_parc` | `neuro/parcellation/volume` | Thalamic nuclei parcellation (parc.nii.gz) on the T1 grid with label.json. |

<details>
<summary><b>⚙️ Parameters</b> (2)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `type` | enum | `both` | Which FreeSurfer segmentation to convert: thal (thalamic nuclei), hippamyg (hippocampal subfields and amygdala nuclei) or both. Fixed for this App. Options: `thal`, `hippamyg`, `both`. |
| `subdivision` | enum | `default` | Which hippocampal/amygdala segmentation level to use (FreeSurfer hippoAmygLabels files): default (full detail), CA, FS60 or HBT. Ignored for thalamic nuclei. Options: `CA`, `FS60`, `HBT`, `default`. |

</details>

<!-- brainlife-app:end -->

## 🏷️ Versions on brainlife.io

Three Apps are registered from the same branch; they differ only in which segmentation they convert (the `type` option, fixed per App).

| App | Converts | Branch | Run it | Status |
|---|---|---|---|---|
| Convert thalamic, hippocampal and amygdala segmentation into parcellation | both (`type: both`) | [`wb-v1.5_dipy-v1.4.1_app-v1.0`](https://github.com/brainlife/app-generate-parc-thal-amyg-hipp/tree/wb-v1.5_dipy-v1.4.1_app-v1.0) | [doi:10.25663/brainlife.app.734](https://doi.org/10.25663/brainlife.app.734) | current |
| Convert thalamic segmentation into parcellation | thalamic nuclei (`type: thal`) | [`wb-v1.5_dipy-v1.4.1_app-v1.0`](https://github.com/brainlife/app-generate-parc-thal-amyg-hipp/tree/wb-v1.5_dipy-v1.4.1_app-v1.0) | [doi:10.25663/brainlife.app.732](https://doi.org/10.25663/brainlife.app.732) | current |
| Convert hippocampal and amygdala segmentation into parcellation | hippocampal subfields and amygdala nuclei (`type: hippamyg`) | [`wb-v1.5_dipy-v1.4.1_app-v1.0`](https://github.com/brainlife/app-generate-parc-thal-amyg-hipp/tree/wb-v1.5_dipy-v1.4.1_app-v1.0) | [doi:10.25663/brainlife.app.733](https://doi.org/10.25663/brainlife.app.733) | current |

## 🚀 Running the App

### ☁️ On brainlife.io

First run FreeSurfer 7's thalamic nuclei and/or hippocampal subfield segmentation, so the FreeSurfer dataset carries the `thalamic_nuclei` and/or `hippocampal` tags. Then open the App at [doi.org/10.25663/brainlife.app.734](https://doi.org/10.25663/brainlife.app.734) (or the single-structure variant), choose the `neuro/freesurfer` dataset and a T1-weighted image that defines the output space, and press **Execute**.

The App:

1. converts `mri/ThalamicNuclei.v*.T1.FSvoxelSpace.mgz` and/or `mri/lh|rh.hippoAmygLabels-T1*.FSvoxelSpace.mgz` with `mri_convert`; for the hippocampus and amygdala, right-hemisphere labels are offset by 100 and the two hemispheres merged with `fslmaths`;
2. resamples each segmentation to the T1 grid with `mri_vol2vol` (header-based, nearest neighbour);
3. renumbers voxel values with the bundled label tables ([`thal_label.json`](thal_label.json), [`hippamyg_label.json`](hippamyg_label.json)) using nibabel.

`subdivision` selects the hippocampal/amygdala segmentation level: `default` (full detail), `CA`, `FS60` or `HBT`. It is ignored for thalamic nuclei. The outputs are `neuro/parcellation/volume` datasets, usable as ROIs for tractography or network analysis.

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/) and a [FreeSurfer license](https://surfer.nmr.mgh.harvard.edu/registration.html). FreeSurfer tools (in the Connectome Workbench 1.5.0 container) and nibabel (in the DIPY 1.4.1 container) run inside containers.

1. Clone this repository and check out the branch brainlife.io runs: `git checkout wb-v1.5_dipy-v1.4.1_app-v1.0`.
2. Create `config.json` with the paths to your inputs:

   ```json
   {
       "freesurfer": "/input/freesurfer/output",
       "t1": "/input/t1/t1.nii.gz",
       "type": "both",
       "subdivision": "default"
   }
   ```

3. Export your license and run the App:

   ```bash
   export FREESURFER_LICENSE="$(cat ~/freesurfer/license.txt)"
   ./main
   ```

## 📦 Outputs

```text
thal_parc/
├── parc.nii.gz      thalamic nuclei parcellation on the T1 grid
└── label.json
hippamyg_parc/
├── parc.nii.gz      hippocampal subfield and amygdala nuclei parcellation on the T1 grid
└── label.json
```

## 🩺 Troubleshooting

- **`Please set FREESURFER_LICENSE in .bashrc`**: export the contents of your FreeSurfer `license.txt` as `FREESURFER_LICENSE` before running `./main`.
- **`something went wrong. check derivatives and logs`**: a `parc.nii.gz` or `label.json` was not written, usually because the FreeSurfer directory lacks the thalamic or hippocampal segmentation files in `mri/`.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Convert thalamic, hippocampal and amygdala segmentation into parcellation. brainlife.io App. [doi:10.25663/brainlife.app.734](https://doi.org/10.25663/brainlife.app.734)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Garyfallidis et al. Dipy, a library for the analysis of diffusion MRI data. *Frontiers in Neuroinformatics* 8 (2014). [doi:10.3389/fninf.2014.00008](https://doi.org/10.3389/fninf.2014.00008)
- Marcus et al. Informatics and Data Mining Tools and Strategies for the Human Connectome Project. *Frontiers in Neuroinformatics* 5 (2011). [doi:10.3389/fninf.2011.00004](https://doi.org/10.3389/fninf.2011.00004)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Brad Caron

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

[MIT](LICENSE). FreeSurfer itself is distributed under its own [license](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense).

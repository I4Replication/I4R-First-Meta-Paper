# I4R First Meta Paper Replication Package

This repository contains the replication materials for the I4R First Meta Paper. The replication instructions below are adapted from the original `README.txt` located in the `Replication Package` folder.

## 1. System Requirements

### 1a. Software dependencies and operating systems

- **StataNow 19.5 (Basic Edition)** – should also work with older versions. Required Stata packages:
  - `ssc install estout`
  - `ssc install coefplot`
  - `ssc install kdens`
  - `ssc install moremata`
  - `ssc install tabout`
- **R 4.3.1** – should also work with older versions. Install the following packages:
  - `NlcOptim`
  - `fdrtool`
  - `pracma`
  - `gdata`
  - `spatstat`
  - `rddensity`
  - `ggplot2`
  - `gtools`
  - `shiny`
  - `methods`

### 1b. Tested versions

- macOS Monterey 12.2.1
- StataNow 19.5 (Basic Edition)
- R 4.3.1 "Beagle Scouts"

### 1c. Required hardware

No non-standard hardware is required.

## 2. Installation Guide

### 2a. Instructions

- Stata requires a license from StataCorp.
- R can be freely downloaded from [r-project.org](https://www.r-project.org/).

### 2b. Typical install time

Installation of Stata and R is nominal for each, taking less than 10 minutes on a typical desktop computer.

## 3. Demo

### 3a. Running on the provided data

Within the `Replication Package` folder, execute the following Stata `.do` files as needed:

- `make figure 1.do`
- `make figure 2 and 4.do`
- `make figure 3.do`
- `make figure 5 7 8 16.do`
- `make figure 6 9 10.do`
- `make figure 11 12 13 14.do`

For **Figure 15 (Applying Elliot et al. 2022)**:
1. Navigate to the `figure 15` folder.
2. Run `1 prepare input data.do` to generate three `.csv` files.
3. Run `2 run elliot at 5.R` to produce three PDF figures and the file `table_elliot.csv`.

For tables:
- `make table 1 14 15 17.do`
- `make table 6 7 8 9.do`
- Tables 2–5 are created manually.

For **Table 16 (Applying Andrews and Kasy 2019)**:
1. Navigate to the `table 16` folder.
2. Run `1 prepare input data.do` to generate six `.csv` files.
3. Run `app.R` and, using the GUI, load each generated CSV to estimate the model. The numbers are then transcribed into Table 16 manually.

### 3b. Expected output

- Executing all `.do` files generates 35 PDF figures in the `figures` folder and 12 `.tex` files in the `tables` folder.
- Running the Figure 15 scripts produces three figures and one CSV file in the `figure 15` folder.

### 3c. Expected run time

Approximate run times on a typical desktop computer:

- `make figure 1.do` – 6.2 s
- `make figure 2 and 4.do` – 5.6 s
- `make figure 3.do` – 1.0 s
- `make figure 5 7 8 16.do` – 3.3 s
- `make figure 6 9 10.do` – 4.3 s
- `make figure 11 12 13 14.do` – 13.2 s
- Figure 15 – under 1 min
- `make table 1 14 15 17.do` – 0.9 s
- `make table 6 7 8 9.do` – 0.08 s
- Table 16 – under 1 min
- **Total** – less than 10 minutes

## 4. Instructions for Use

### 4a. Running the software on your data

Each `.do` file in the replication folder is self‑contained. To produce a particular figure or table, open the corresponding `.do` file in Stata and choose *Execute*. Figures 1–14 and 16, as well as Tables 1, 6–10, 14, 15, and 17, are generated solely in Stata. Figure 15 and Table 16 require running both Stata and R as described above.

### 4b. Reproduction instructions

See section 4a above.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


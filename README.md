<img  align="left" width="150" style="float: left;" src="https://www.upm.es/sfs/Rectorado/Gabinete%20del%20Rector/Logos/UPM/CEI/LOGOTIPO%20leyenda%20color%20JPG%20p.png">
<img  align="right" width="60" style="float: right;" src="http://www.dit.upm.es/figures/logos/ditupm-big.gif">

<br/><br/><br/>

# Residential Network Virtualised with OSM
> 

## About The Project

## Getting Started

If you want to **run the application locally** please proceed with the following steps.

### Prerequisites on W10

The following components are necessary for the execution of the application:
* [Git Bash](https://gitforwindows.org/) (Optionally)
* [Docker Desktop](https://docs.docker.com/docker-for-windows/install/)

_Note: in a similar way it would be in OS and Linux environments_

### Installation

1. Clone this repository.

   ```
   git clone https://github.com/ecalatayudc/Big_data_2020.git
   ```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_Note: you can download the repository as .zip_ 

2. Move to the Big_data_2020/ directory.

   ```sh
   cd Big_data_2020/
   ```
3. Build docker-compose.

   ```sh
   docker-compose build
   ```
4. Run docker-compose up and Compose starts and runs your entire app.

   ```sh
   docker-compose up
   ```
5. Finally visit the following URL to access web application: 
   <br> http://localhost:5000/flights/delays/predict_kafka </br>

## Contributors

Thanks to:
- [@ecalatayudc](https://github.com/ecalatayudc)
- [@jrodriguezo](https://github.com/jrodriguezo)

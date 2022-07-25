# Road Traffic Accident Database

> Road Traffic Accident Database (RTADB) is the database for analysis of road traffic accidents.
> The database is scalable using your data set related to traffic accidents.
> This repository contains scripts that build the database for analyzing traffic accident data.

## 🚀Usage

### Starting Up the Database

Make sure you have [docker](https://www.docker.com/) installed.

In order to run the container capable of serving a PostGIS-enabled database, the following command at the root of your project:

    docker-compose up -d

About `postgis/postgis` image used this container, see the [page](https://github.com/postgis/docker-postgis).

### Sample Database

Once you have started a database container, you can build the sample database using the [R script](R/build-database.R)(depends R ≥ 4.1) contained in this repository.

The sample database contains followings:

- Road traffic accidents data
- Administrative area data
- Land use data
- Traffic volume data
- Japanese regional grid squares data

To use these data, download each and place it in dir, `data-raw/[data-name]/`

Each data using the sample database be obtained from followings:

| **Directory** | **Description** | **Download** |
| -- | -- |:--:|
| `traffic-accidents` | Traffic accident data provided by Aichi prefectural police. | - |
| `administrative-areas` | Information on administrative areas such as cities and wards. Information on the names of the administrative districts of Aichi Prefecture is included in [`aichi.csv`](data-raw/administrative-areas/aichi.csv). Spatial information on administrative areas is provided by R Package 'jpndistrict'. | - |
| `population-cencus` | Population of each municipality in Aichi Prefecture. | [here](https://www.e-stat.go.jp/stat-search/files?page=1&layout=datalist&toukei=00200521&tstat=000001049104&cycle=0&tclass1=000001049105&stat_infid=000032143614&tclass2val=0) |
| `land-use` | Data classified by land in Aichi Prefecture. | [here](https://nlftp.mlit.go.jp/kokjo/inspect/landclassification/land/dojyou.html) |
| `traffic-volumes-points` | Location data of the spot traffic volume measurement points. The detailed version A of location information of spot traffic volume is included. | - |
| `traffic-volumes` | Spot traffic volume mesurement data. | [here](https://www.jartic.or.jp/service/opendata/) |

## 📝 License

This project is [MIT](LICENSE) licensed.

# Upload packages
library(terra)
library(tidyverse)
library(sf)
library(mapview)

#### Hidrographic Unit ####
uh <- sf::st_read(dsn = "Data/Hydrographic_Units/UH.shp")
str(uh)
colnames(uh)
nrow(uh)
summary(as.factor(uh$NOMBRE))
uh_rb <- uh %>% filter(NOMBRE == "Cuenca Rímac")
str(uh_rb)
mapview::mapview(uh_rb)

# Area equal to:
area_rb <- uh_rb$AREA_KM2
paste(area_rb, "km^2")


#### Landslide Cartography ####

landslide <- sf::st_read(dsn = "Data/Landslides_18072025/Peligros Geológicos.shp")
head(landslide)
str(landslide)
colnames(landslide)
plot(landslide)

#### Landslide Points inside Rimac Basin ####

# Check CRS:
if(sf::st_crs(uh_rb) != sf::st_crs(landslide)) {
  landslide <- sf::st_transform(landslide, crs = sf::st_crs(uh_rb))
}
# Spatial filter: landslides within Rimac Basin:
landslide_rb <- landslide[sf::st_within(landslide, uh_rb, sparse = FALSE), ]
# Check results by view:
mapview::mapview(landslide_rb) + mapview::mapview(uh_rb)
# Check number of landslides:
nrow(landslide_rb)
print(paste("Number of landslides in Rímac Basin:", nrow(landslide_rb)))

# Check the time spam of landslide so it is easy to visualize events in chronological order
head(landslide_rb)
landslide_rb_check <- landslide_rb %>% dplyr::mutate_if(is.character, as.factor)
summary(landslide_rb_check)
nrow(landslide_rb_check$COD_INV)

### Medidas adoptadas - Observaciones ####
summary(as.factor(landslide_rb$DES_MEADOP))
summary(as.factor(landslide_rb$RE_ME_E_NE))
summary(as.factor(landslide_rb$OTRA_EVISU))

# After check variables important select new variables and rename:
landslide_rb <- landslide_rb %>%
  dplyr::select(COO_NORTE, COO_ESTE, UBIGEO, NM_DPTO, NM_PROV, NM_DIST, NM_SECTOR,
                FECHA, TIP_PELIGR, NOM_PELIGR, DENOMINACI, CREATIONDA, ZONA)
mapview::mapview(landslide_rb)
# Rename variables:
landslide_rb <- landslide_rb %>% dplyr::rename(
  north = COO_NORTE,
  east = COO_ESTE,
  ubigeo = UBIGEO,
  department = NM_DPTO,
  province = NM_PROV,
  district = NM_DIST,
  sector = NM_SECTOR,
  event_date = FECHA,
  hazard_type = TIP_PELIGR,
  hazard_name = NOM_PELIGR,
  denomination = DENOMINACI,
  creation_date = CREATIONDA,
  zone = ZONA
)
landslide_rb <- landslide_rb %>% dplyr::select(
  north,east,ubigeo,department,province,district,sector,event_date,hazard_type,hazard_name,
  denomination, creation_date, zone)
mapview::mapview(landslide_rb)

# Summarize:
landslide_rb <- landslide_rb %>% dplyr::mutate_if(is.character, as.factor)
summary(landslide_rb)










  

  
  
  




set -x

	#ogrinfo -al - so folder will tell you all the attributes
	#don't know how to see the name


	#first, get only the counties you are interested in reclip

ogr2ogr -where "name ='Santa Barbara'" sb_extract tl_2018_us_county/tl_2018_us_county.shp

	#reproject 

ogr2ogr -t_srs "EPSG: 3310" sb_extract_albers sb_extract

	#next clip the raster
	#rasters that will be clipped and reprojected to

rasters="crefl2_A2019257204722-2019257205812_250m_ca-south-000_143.tif"

	#shapefiles we will be using to clip

roi=sb_extract_albers/tl_2018_us_county.shp
	
	#create main arguments
	
common_args="-dstalpha -of GTiff -co COMPRESS=DEFLATE -overwrite"

clip_args="-cutline $roi -crop_to_cutline"

project_args="-t_srs EPSG:3310"

	#run loop

for file in $rasters
do
	gdalwarp $common_args $clip_args $file ${file}_clipped.tif
	 
	gdalwarp $common_args $project_args ${file}_clipped.tif ${file}_albers.tif
done
#Chapter 11 - Image data
#Other reference: https://www.bioconductor.org/packages/devel/bioc/vignettes/EBImage/inst/doc/EBImage-introduction.html
#https://staff.fnwi.uva.nl/r.vandenboomgaard/IPCV20172018/LectureNotes/IP/Images/ImageInterpolation.html
#https://bioconductor.org/packages/devel/bioc/manuals/EBImage/man/EBImage.pdf

#Install package
install.packages("BiocManager") 
install.packages("htmlwidgets")
BiocManager::install("EBImage")
BiocManager::install("MSMB")
#BiocManager::install(c("GenomicFeatures", "AnnotationDbi"))

#Libraries
library(EBImage)
library(htmlwidgets)

##################################
##Read, export, and Visualization
##################################

#Read file and #Visualize image
#Supported formats https://docs.openmicroscopy.org/bio-formats/5.5.3/supported-formats.html
imagefile = system.file("images", "mosquito.png", package = "MSMB")
#system.file("images", package = "EBImage")
#system.file("images", package = "MSMB")
mosq = readImage(imagefile)

#EBImage::display(mosq) #Error in text.default(x = 85, y = 800, label = "A mosquito", adj = 0,  : plot.new has not been called yet
##Alternatively, the image can be displayed using R’s build-in plotting facilities by calling display with the argument method = "raster"
EBImage::display(mosq, method = "raster")
#plot(mosq)
text(x = 85, y = 800, label = "A mosquito", adj = 0, col = "orange", cex = 1.5)

#Another image
imagefile = system.file("images", "hiv.png", package = "MSMB")
hivc = readImage(imagefile)
EBImage::display(hivc, method = "raster")

#Another image
nuc = readImage(system.file("images", "nuclei.tif", package = "EBImage"))
EBImage::display(1 - nuc, all = TRUE,  method = "raster") #Multiple frames: top-bottom, left-right
EBImage::display(1 - nuc, frame = 2,  method = "raster") #Only frame no.2

#Question 11.2 
EBImage::display(nuc, frame = 1,  method = "raster")


#Export read *.png to *.jpeg
output_file = file.path(tempdir(), "hivc.jpeg")
writeImage(hivc, output_file, quality = 85)


##################################
##Inspection
##################################
class(nuc) 
class ? Image
dim(nuc) 
object.size(nuc) |> format(units = "Mb") #Filesize
(object.size(nuc) / prod(dim(nuc))) |> format() |> paste("per pixel") # "8 bytes per pixel"

#How much RAM would you expect a three color, 16 Megapixel image to occupy?
#1 Byte = 8 Bit 1 Kilobyte = 1,024 Bytes 1 Megabyte = 1,048,576 Bytes 1 Gigabyte = 1,073,741,824 Bytes
#https://www.quora.com/Is-1-GB-equal-to-1024-MB-or-1000-MB
#https://4nsi.com/how-do-i-calculate-the-file-size-for-a-digital-image/
3ch x 16Megapixel/ch x 8bits/ch = 384e+06 bits
384e+06 bits/ 8bits/byte = 4.8e+07 bytes
4.8e+07/ 1024 bytes/Megabyte = 46875MB
46875MB / 1024 MB/GB = 45.7 GB


#Accessing the matrix
nuc[1,10,4]
imageData(nuc)[1,10,4]
imageData(nuc)[1,10,1:4]
hist(nuc[1,10,1:4]) #Same xy pixel across 4 channels




##################################
##Image processing
##################################
##########
#Normalization = Intensity values linear scaling
#https://rdrr.io/bioc/EBImage/man/normalize.html

max(mosq)
min(mosq)
hist(mosq)

#Normalize to 0-4
mosq_norm = EBImage::normalize(mosq, ft=c(0,4))

max(mosq_norm)
min(mosq_norm)
hist(mosq_norm)

#Plot
EBImage::display(mosq, frame = 1,  method = "raster")
EBImage::display(mosq_norm, frame = 1,  method = "raster")

##########
#Transformation
#Transpose
mosqtransp =EBImage::transpose(mosq)
EBImage::display(mosqtransp, frame = 1,  method = "raster")

#Rotate, translate, flip
mosqrot   = EBImage::rotate(mosq, angle = 30) #image clockwise 
mosqshift = EBImage::translate(mosq, v = c(100, 170))
mosqflip  = flip(mosq)
mosqflop  = flop(mosq)


##########
#Image filter


#Smoothing
#Erode
#Dilates




##################################
##Image segmentation
##################################
mosqcrop   = mosq[100:438, 112:550]
mosqthresh = mosq > 0.5 #data type = boolean

######
#Task
#Our goal now is to computationally identify and quantitatively characterize the cells in these images
#######
imagefiles = system.file("images", c("image-DAPI.tif", "image-FITC.tif", "image-Cy3.tif"), package = "MSMB")
cells = readImage(imagefiles)

#Visualize
EBImage::display(cells, all = TRUE,  method = "raster")

#Check range (min, max)
apply(cells, 3, range) #check dynamic range - 16bit (0-2^16) from a scanner using 2^11

#Rescale 
#Using normalize
EBImage::normalize(cells, ft=(0,1))


#Adaptive thresholding
# Voronoi tessellation

##################################
#Feature extraction
##################################


##################################
###Image analysis
##################################


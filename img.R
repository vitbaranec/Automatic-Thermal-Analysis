library(Thermimage)
f<-paste0(in_img_file_name)
print(f)
img<-readflirJPG(f, exiftoolpath="installed")
dim(img)

cams<-flirsettings(f, exiftoolpath="installed", camvals="")
head(cbind(cams$Info), 20) # Large amount of Info, show just the first 20 tages for readme

plancks<-flirsettings(f, exiftoolpath="installed", camvals="-*Planck*")
unlist(plancks$Info)

ObjectEmissivity<-  cams$Info$Emissivity              # Image Saved Emissivity - should be ~0.95 or 0.96
dateOriginal<-cams$Dates$DateTimeOriginal             # Original date/time extracted from file
dateModif<-   cams$Dates$FileModificationDateTime     # Modification date/time extracted from file
PlanckR1<-    cams$Info$PlanckR1                      # Planck R1 constant for camera  
PlanckB<-     cams$Info$PlanckB                       # Planck B constant for camera  
PlanckF<-     cams$Info$PlanckF                       # Planck F constant for camera
PlanckO<-     cams$Info$PlanckO                       # Planck O constant for camera
PlanckR2<-    cams$Info$PlanckR2                      # Planck R2 constant for camera
ATA1<-        cams$Info$AtmosphericTransAlpha1        # Atmospheric Transmittance Alpha 1
ATA2<-        cams$Info$AtmosphericTransAlpha2        # Atmospheric Transmittance Alpha 2
ATB1<-        cams$Info$AtmosphericTransBeta1         # Atmospheric Transmittance Beta 1
ATB2<-        cams$Info$AtmosphericTransBeta2         # Atmospheric Transmittance Beta 2
ATX<-         cams$Info$AtmosphericTransX             # Atmospheric Transmittance X
OD<-          cams$Info$ObjectDistance                # object distance in metres
FD<-          cams$Info$FocusDistance                 # focus distance in metres
ReflT<-       cams$Info$ReflectedApparentTemperature  # Reflected apparent temperature
AtmosT<-      cams$Info$AtmosphericTemperature        # Atmospheric temperature
IRWinT<-      cams$Info$IRWindowTemperature           # IR Window Temperature
IRWinTran<-   cams$Info$IRWindowTransmission          # IR Window transparency
RH<-          cams$Info$RelativeHumidity              # Relative Humidity
h<-           cams$Info$RawThermalImageHeight         # sensor height (i.e. image height)
w<-           cams$Info$RawThermalImageWidth          # sensor width (i.e. image width)

temperature<-raw2temp(img, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                      PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2, 
                      ATA1, ATA2, ATB1, ATB2, ATX)
str(temperature)  

#library(fields) # should be imported when installing Thermimage
#plotTherm(temperature, h=h, w=w, minrangeset=0, maxrangeset=100, trans="rotate270.matrix")

write.csv(temperature, out_csv_filename)

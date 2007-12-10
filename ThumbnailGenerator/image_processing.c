#include <stdio.h>
#include <stdlib.h>
#include <wand/MagickWand.h>

int main()
{
#define ThrowWandException(wand) \
{ \
  char \
    *description; \
 \
  ExceptionType \
    severity; \
 \
  description=MagickGetException(wand,&severity); \
  (void) fprintf(stderr,"%s %s %lu %s\n",GetMagickModule(),description); \
  description=(char *) MagickRelinquishMemory(description); \
  exit(-1); \
}

  MagickBooleanType
    status;

  MagickWand
    *magick_wand;

  // if (argc != 3)
  //   {
  //     (void) fprintf(stdout,"Usage: %s image thumbnail\n",argv[0]);
  //     exit(0);
  //   }
  /*
    Read an image.
  */
  MagickWandGenesis();
  magick_wand=NewMagickWand();
  status=MagickReadImage(magick_wand,'sample_images/1920x1200.jpg');
  if (status == MagickFalse)
    ThrowWandException(magick_wand);
  /*
    Turn the images into a thumbnail sequence.
  */
  int num_sizes = 6;
  int sizes[num_sizes];
  sizes[0] = 60;
  sizes[1] = 85;
  sizes[2] = 100;
  sizes[3] = 240;
  sizes[4] = 600;
  sizes[5] = 640;
  
  int i;
  MagickResetIterator(magick_wand);
  while (MagickNextImage(magick_wand) != MagickFalse)
    for(i = 0; i < num_sizes; ++i)
    {
      MagickThumbnailImage(magick_wand,sizes[i],sizes[i]/1.33);
      MagickExtentImage(magick_wand,sizes[i],sizes[i]/1.33,sizes[i]/2,(sizes[i]/1.33)/2);
      status=MagickWriteImages(magick_wand,'output/THUMB-1920.jpg',MagickTrue);
    }
  /*
    Write the image then destroy it.
  */
  if (status == MagickFalse)
    ThrowWandException(magick_wand);
  magick_wand=DestroyMagickWand(magick_wand);
  MagickWandTerminus();
  return(0);
}
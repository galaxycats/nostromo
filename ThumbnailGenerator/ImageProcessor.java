import java.awt.image.renderable.ParameterBlock;

import javax.media.jai.BorderExtenderConstant;
import javax.media.jai.InterpolationBicubic;
import javax.media.jai.JAI;
import javax.media.jai.PlanarImage;

public class ImageProcessor {

  private int[] validImageSizes;
  private PlanarImage image;
  private String outputPath;
  private int quality;
  private String format;
  private static final float ASPECT_RATIO_4_3 = 1.33f;

  ImageProcessor(int[] sizesToGenerate, String pathToImage, String outputPath, int quality) {
    this.validImageSizes = sizesToGenerate;
    this.image = JAI.create("fileload", pathToImage);
    this.outputPath = outputPath;
    this.quality = quality;
    this.format = "jpeg";
  }

  public String getOutputPath() {
    return this.outputPath;
  }

  public String getOutputPath(int thumbWidth) {
    return this.outputPath + "/thumb_" + getImage().getWidth() + "x" + getImage().getHeight() + "_" + thumbWidth + "." + getFormat();
  }

  public int getQuality() {
    return this.quality;
  }

  public PlanarImage getImage() {
    return this.image;
  }

  public String getFormat() {
    return this.format;
  }

  public void createThumbnailsForAllImageSizes() {
    for(int i = 0; i < validImageSizes.length; i++) {
      createThumbnail(validImageSizes[i]);
    }
  }

  private void createThumbnail(int thumbWidth) {
    float imageRatio = (float)getImage().getWidth() / (float)getImage().getHeight();
    int thumbHeight = (int)(thumbWidth / imageRatio);

    ParameterBlock parameterBlock = new ParameterBlock();
    parameterBlock.addSource(getImage());
    parameterBlock.add(thumbWidth / (float)getImage().getWidth());
    parameterBlock.add(thumbHeight / (float)getImage().getHeight());
    parameterBlock.add(0.0F);
    parameterBlock.add(0.0F);
//    parameterBlock.add(new InterpolationBicubic(100));

    // This is the scaled image
    PlanarImage thumbnail = JAI.create("scale", parameterBlock);

    // Create the border
    parameterBlock = new ParameterBlock();
    parameterBlock.addSource(thumbnail);
    parameterBlock.add(new Integer(150));
    parameterBlock.add(new Integer(150));
    parameterBlock.add(new Integer(150));
    parameterBlock.add(new Integer(150));
    parameterBlock.add(new BorderExtenderConstant(new double[]{255.,255.,255.}));

     // This is the thumbnail with a border
    thumbnail = JAI.create("border", parameterBlock);

    // The border will be set "outside" the original image extents,
    // which will cause problems when we proceed with the cropping.
    // Reposition it so the image origin (0,0) will solve the problem.
    parameterBlock = new ParameterBlock();
    parameterBlock.addSource(thumbnail);
    parameterBlock.add(150f);
    parameterBlock.add(150f);
    thumbnail = JAI.create("translate", parameterBlock);

    // Crop the image
    parameterBlock = new ParameterBlock();
    parameterBlock.addSource(thumbnail);
    thumbHeight = (int)(thumbWidth / ASPECT_RATIO_4_3);
    float xBandOrigin = (thumbnail.getWidth() - thumbWidth) / 2f;
    float yBandOrigin = (thumbnail.getHeight() - thumbHeight) / 2f;
    parameterBlock.add(xBandOrigin);
    parameterBlock.add(yBandOrigin);
    parameterBlock.add(new Float(thumbWidth));
    parameterBlock.add(new Float(thumbHeight));

    // This is the cropped thumbnail
    thumbnail = JAI.create("crop", parameterBlock);

    // Translate the thumbnail to position it correctly
    parameterBlock = new ParameterBlock();
    parameterBlock.addSource(thumbnail);
    parameterBlock.add(-xBandOrigin);
    parameterBlock.add(-yBandOrigin);

    thumbnail = JAI.create("translate", parameterBlock);

    // save thumbnail image
    parameterBlock = new ParameterBlock();
    parameterBlock.addSource(thumbnail);
    parameterBlock.add(getOutputPath(thumbWidth));
    parameterBlock.add(getFormat());

    JAI.create("filestore", parameterBlock);
  }

}
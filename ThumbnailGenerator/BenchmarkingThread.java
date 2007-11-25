
/*
 * BenchmarkingThread.java
 *
 * Version 1.0  Nov 25, 2007
 *
 * Copyright notice
 *
 * Brief description
 *
 * (c) 2007 by dbreuer
 */

/**
 * Documentation comment without implementation details.
 * Use implementation comments to describe details of the implementation.
 * Comment lines should not be longer than 70 characters.
 *
 * @author dbreuer
 * @version 1.0  Nov 25, 2007
 *
 */
public class BenchmarkingThread extends Thread {

  private String pathToImage;
  private int[] sizesToGenerate;

  public BenchmarkingThread(String pathToImage, int[] sizesToGenerate) {
    this.pathToImage = pathToImage;
    this.sizesToGenerate = sizesToGenerate;
  }

  public String getPathToImage() {
    return this.pathToImage;
  }

  public int[] getSizeToGenerate() {
    return this.sizesToGenerate;
  }

  public void run() {
    ImageProcessor imageProcessor = new ImageProcessor(getSizeToGenerate(), getPathToImage(), "./output", 80);
    imageProcessor.createThumbnailsForAllImageSizes();
  }

}

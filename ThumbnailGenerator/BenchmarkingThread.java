
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

  private ImageProcessor imageProcessor;
  private int runs;
  private String nameOfImage;

  public BenchmarkingThread(ImageProcessor imageProcessor, int runs, String nameOfImage) {
    this.imageProcessor = imageProcessor;
    this.runs = runs;
    this.nameOfImage = nameOfImage;
  }

  public void run() {
    long startTime, stopTime;
    startTime = System.currentTimeMillis();
    for(int i = 0; i < runs; i++) {
      imageProcessor.createThumbnailsForAllImageSizes();
    }
    stopTime = System.currentTimeMillis();
    System.out.println("Time taken to generate thumbnails for '" + nameOfImage + "': " + (stopTime - startTime));
  }

}

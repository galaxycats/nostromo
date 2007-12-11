import javax.media.jai.UntiledOpImage;

public class ImageProcessorBenchmark {

  public static final int IMAGE_SIZE_THUMB                 = 60;
  public static final int IMAGE_SIZE_THUMB_LIST            = 85;
  public static final int IMAGE_SIZE_THUMB_DETAIL_VIEW     = 85;
  public static final int IMAGE_SIZE_TOPOFFERED            = 100;
  public static final int IMAGE_SIZE_TOPOFFERED_BIG        = 240;
  public static final int IMAGE_SIZE_BIG                   = 300;
  public static final int IMAGE_SIZE_XXL                   = 640;

  public static void main(String[] args) {
    System.out.println("###########################################");
    System.out.println("# BENCHMARKING IMAGE PROCESSING WITH JAVA #");
    System.out.println("# --------------------------------------- #");
    System.out.println("# java ImageProcessorBenchmark <runs>     #");
    System.out.println("###########################################");
    System.out.println();
    System.out.println("Preparing benchmark ...");
    System.out.println();

    int[] sizesToGenerate = new int[6];
    sizesToGenerate[0] = IMAGE_SIZE_THUMB;
    sizesToGenerate[1] = IMAGE_SIZE_THUMB_LIST;
    sizesToGenerate[2] = IMAGE_SIZE_TOPOFFERED;
    sizesToGenerate[3] = IMAGE_SIZE_TOPOFFERED_BIG;
    sizesToGenerate[4] = IMAGE_SIZE_BIG;
    sizesToGenerate[5] = IMAGE_SIZE_XXL;

    String[] testImages = new String[6];
    testImages[0] = "./sample_images/1920x1200.jpg";
    testImages[1] = "./sample_images/1600x1000.jpg";
    testImages[2] = "./sample_images/1280x800.jpg";
    testImages[3] = "./sample_images/1024x640.jpg";
    testImages[4] = "./sample_images/800x500.jpg";
    testImages[5] = "./sample_images/640x400.jpg";

    int n = (args.length > 0 && args[0] != null) ? Integer.parseInt(args[0]) : 50;

    System.out.println("Performing Benchmark with " + n + " runs ...");
    System.out.println();
    long startTime, stopTime;
    long accumulatedTime = 0;

    // Generate Threads
    BenchmarkingThread[] threads = new BenchmarkingThread[6];
    for (int i = 0; i < threads.length; i++) {
      // This is not real world stuff, cause we are reading every image before generating its thumbnails
//      ImageProcessor imageProcessor = new ImageProcessor(sizesToGenerate, testImages[i], "./output", 80);
//      threads[i] = new BenchmarkingThread(imageProcessor, n, testImages[i]);
      threads[i] = new BenchmarkingThread(sizesToGenerate, testImages[i], "./output", 80, n);
    }

    for(int i = 0; i < threads.length; i++) {
      threads[i].start();
//      accumulatedTime += (stopTime - startTime);
    }

//    for(int i = 0; i < testImages.length; i++) {
//      ImageProcessor imageProcessor = new ImageProcessor(sizesToGenerate, testImages[i], "./output", 80);
//      startTime = System.currentTimeMillis();
//      for(int j = 0; j < n; j++) {
//        imageProcessor.createThumbnailsForAllImageSizes();
//      }
//      stopTime = System.currentTimeMillis();
//      accumulatedTime += (stopTime - startTime);
//      System.out.println("Time taken to generate thumbnails for '" + testImages[i] + "': " + (stopTime - startTime) + " (" + accumulatedTime + ")");
//    }

    System.out.println();
    System.out.println();
    System.out.println("-------------------------------- Total: " + accumulatedTime);
    System.out.println();
    System.out.println("Done!");
    System.out.println();
  }
}
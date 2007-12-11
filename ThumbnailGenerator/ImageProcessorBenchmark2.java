import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;

public class ImageProcessorBenchmark2 {

  public static final int IMAGE_SIZE_THUMB = 60;
  public static final int IMAGE_SIZE_THUMB_LIST = 85;
  public static final int IMAGE_SIZE_TOPOFFERED = 100;
  public static final int IMAGE_SIZE_TOPOFFERED_BIG = 240;
  public static final int IMAGE_SIZE_BIG = 300;
  public static final int IMAGE_SIZE_XXL = 640;

  public static final String CONVERT_PROG = "/opt/local/bin/convert";
  /**
   * Copied form http://www.darcynorman.net/2005/03/15/jai-vs-imagemagick-image-resizing/
   *
   * Uses a Runtime.exec()to use imagemagick to perform the given
   * conversion operation. Returns true on success, false on failure.
   * Does not check if either file exists.
   *
   */
  private static boolean convert(File in, String outpath, int[] sizesToGenerate, int quality) {
    if (quality < 0 || quality > 100) {
      quality = 75;
    }

    ArrayList<String> command = new ArrayList<String>(10);

    // note: CONVERT_PROG is a class variable that stores the location
    // of ImageMagick’s convert command
    // it might be something like “/usr/local/magick/bin/convert” or
    // something else, depending on where you installed it.
    command.add(CONVERT_PROG);
    command.add(in.getAbsolutePath());
    for (int i = 0; i < sizesToGenerate.length-1; i++) {
      command.add("(");
      command.add("+clone");
      command.add("-thumbnail");
      command.add("" + sizesToGenerate[i]);
      command.add("-background");
      command.add("white");
      command.add("-gravity");
      command.add("center");
      command.add("-extent");
      command.add("" + sizesToGenerate[i] + "x" + (int)(sizesToGenerate[i]/1.33));
      command.add("-quality");
      command.add("" + quality);
      command.add("-write");
      command.add("" + outpath + "/THUMB-" + in.getName() + "-" + sizesToGenerate[i] + ".jpg");
      command.add("+delete");
      command.add(")");
    }
    command.add("-thumbnail");
    command.add("" + sizesToGenerate[sizesToGenerate.length-1]);
    command.add("-background");
    command.add("white");
    command.add("-gravity");
    command.add("center");
    command.add("-extent");
    command.add("" + sizesToGenerate[sizesToGenerate.length-1] + "x" + (int)(sizesToGenerate[sizesToGenerate.length-1]/1.33));
    command.add("-quality");
    command.add("" + quality);
    command.add(outpath + "/THUMB-" + sizesToGenerate[sizesToGenerate.length-1] + "-" + in.getName());

//    System.out.println(command);

    return exec((String[]) command.toArray(new String[1]));
  }

  /**
   * Tries to exec the command, waits for it to finsih, logs errors if
   * exit status is nonzero, and returns true if exit status is 0
   * (success).
   *
   * @param command
   *          Description of the Parameter
   * @return Description of the Return Value
   */
  private static boolean exec(String[] command) {
    Process proc;

    try {
//      System.out.println("Trying to execute command " +
//      Arrays.asList(command));
      proc = Runtime.getRuntime().exec(command);
    } catch (IOException e) {
      System.out.println("IOException while trying to execute " + command);
      return false;
    }

    // System.out.println("Got process object, waiting to return.");

    int exitStatus;

    while (true) {
      try {
        exitStatus = proc.waitFor();
        // any error message?
        StreamGobbler errorGobbler = new
            StreamGobbler(proc.getErrorStream(), "ERROR");

        // any output?
        StreamGobbler outputGobbler = new
            StreamGobbler(proc.getInputStream(), "OUTPUT");

        // kick them off
        errorGobbler.start();
        outputGobbler.start();
        break;
      } catch (java.lang.InterruptedException e) {
        System.out.println("Interrupted: Ignoring and waiting");
      }
    }
    if (exitStatus != 0) {
      System.out.println("Error executing command: " + exitStatus);
    }
    return (exitStatus == 0);
  }

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
    testImages[0] = "sample_images/1920x1200.jpg";
    testImages[1] = "sample_images/1600x1000.jpg";
    testImages[2] = "sample_images/1280x800.jpg";
    testImages[3] = "sample_images/1024x640.jpg";
    testImages[4] = "sample_images/800x500.jpg";
    testImages[5] = "sample_images/640x400.jpg";

    int n = (args.length > 0 && args[0] != null) ? Integer.parseInt(args[0])
        : 50;

    System.out.println("Performing Benchmark with " + n + " runs ...");
    System.out.println();
    long startTime, stopTime;
    long accumulatedTime = 0;

    for (int i = 0; i < testImages.length; i++) {
      startTime = System.currentTimeMillis();
      System.out.println("converting " + testImages[i] + " ...");
      for (int j = 0; j < n; j++) {
        // Generate Thumbnails for all test images in './output'
        convert(new File(testImages[i]), "./output", sizesToGenerate, 75);
      }
      stopTime = System.currentTimeMillis();
      accumulatedTime += (stopTime - startTime);
      System.out.println("Time taken to generate thumbnails for '"
          + testImages[i] + "': " + (stopTime - startTime) + " ("
          + accumulatedTime + ")");
    }

    System.out.println();
    System.out.println();
    System.out.println("-------------------------------- Total: "
        + accumulatedTime/1000.0 + "s");
    System.out.println();
    System.out.println("Done!");
    System.out.println();
  }
}


class StreamGobbler extends Thread {

  InputStream is;
  String type;
  OutputStream os;

  StreamGobbler(InputStream is, String type) {
    this(is, type, null);
  }

  StreamGobbler(InputStream is, String type, OutputStream redirect) {
    this.is = is;
    this.type = type;
    this.os = redirect;
  }

  public void run() {
    try {
      PrintWriter pw = null;
      if (os != null)
        pw = new PrintWriter(os);

      InputStreamReader isr = new InputStreamReader(is);
      BufferedReader br = new BufferedReader(isr);
      String line = null;
      while ((line = br.readLine()) != null) {
        if (pw != null)
          pw.println(line);
        System.out.println(type + ">" + line);
      }
      if (pw != null)
        pw.flush();
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }
  }
}
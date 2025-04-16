import java.util.*;

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
class Player {

    public static void main(String args[]) {
        Scanner in = new Scanner(System.in);
        int w = in.nextInt(); // width of the building.
        int h = in.nextInt(); // height of the building.
        int n = in.nextInt(); // maximum number of turns before game over. (not used)
        int x0 = in.nextInt();
        int y0 = in.nextInt();

        int left = 0;
        int right = w - 1;
        int top = 0;
        int bottom = h - 1;

        // game loop
        while (true) {
            String bombDir = in.next(); // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)

            if (bombDir.contains("U")) {
                bottom = y0 - 1;
            } else if (bombDir.contains("D")) {
                top = y0 + 1;
            }
            if (bombDir.contains("L")) {
                right = x0 - 1;
            } else if (bombDir.contains("R")) {
                left = x0 + 1;
            }

            x0 = (left + right) / 2;
            y0 = (top + bottom) / 2;


            // the location of the next window Batman should jump to.
            System.out.println(x0 + " " + y0);
        }
    }
}
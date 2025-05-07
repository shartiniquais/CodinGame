import java.util.*;

class Solution {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);

        int l = in.nextInt();
        int h = in.nextInt();
        in.nextLine();

        String t = in.nextLine().toUpperCase();

        String[] asciiArt = new String[h];
        for (int i = 0; i < h; i++) {
            asciiArt[i] = in.nextLine();
        }

        StringBuilder[] result = new StringBuilder[h];
        for (int i = 0; i < h; i++) {
            result[i] = new StringBuilder();
        }

        for (char c : t.toCharArray()) {
            int index;
            if (c >= 'A' && c <= 'Z') {
                index = c - 'A';
            } else {
                index = 26;
            }

            for (int i = 0; i < h; i++) {
                int start = index * l;
                int end = start + l;
                result[i].append(asciiArt[i].substring(start, end));
            }
        }

        for (int i = 0; i < h; i++) {
            System.out.println(result[i].toString());
        }
    }
}

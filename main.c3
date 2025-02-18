import std::io;
import std::io::file;
import libc;
import std::math::random;
import std::core::mem;

const String VOWS = "aeiou";
const String CONS = "bcdfghjklmnpqrstvwxyz";

macro rand_vow() => random::rand_in_range(0, VOWS.len-1);
macro rand_con() => random::rand_in_range(0, CONS.len-1);


fn String gen_word(int min_syls, int max_syls) {
    String final = "";
    for (int i = 0; i < random::rand_in_range(min_syls, max_syls); i++ ) {
        int rv = rand_vow();
        int rc = rand_con();

        switch (random::rand_in_range(0, 5))
        {
            case 0: 
                final = String.tconcat(final,(String){CONS[rc], VOWS[rv]});
            case 1: 
                final = String.tconcat(final,(String){VOWS[rv], CONS[rc]});
            case 2: 
                final = String.tconcat(final,(String){CONS[rc], VOWS[rv], CONS[rc]});
            case 3: 
                final = String.tconcat(final,(String){CONS[rc], VOWS[rv], VOWS[rv]});
            case 4: 
                final = String.tconcat(final,(String){CONS[rc], CONS[rc], VOWS[rv]});
            case 5: 
                final = String.tconcat(final,(String){VOWS[rv], CONS[rc], VOWS[rv]});
        }
    }
    return final.copy();
}

fn String mutate_word(String word) {
    
   return word; 
}


fn void main (String[] args) {

    int max_syls = 5;
    int max_words = 1;

    if (args.len > 2) {
        max_words = (int)libc::atoi(args[1]);
        max_syls = (int)libc::atoi(args[2]); 
    }

    for( int i = 0; i < max_words; i++) {
       io::printfn("%s", gen_word(1, max_syls)); 
    }
    
    usz! file_size = file::get_size("test");
    if (catch excuse = file_size) {
        io::printfn("Error getting file size: %s", excuse);
        return;
    }
    io::print(file_size);

    File! file = file::open("test", "r");
    defer (void)file.close();

    if (catch excuse = file) {
        io::printfn("Error openning file: %s", excuse);
        return;
    }

    char[] buffer = mem::new_array(char, file_size); 
    usz! file_read = file.read(buffer);
    if (catch excuse = file_read) {
        io::printfn("Error reading file into buffer: %s", excuse);
        return;
    }

    String[] chosen_words = ((String)buffer).split("\n");
    io::print(chosen_words);
}

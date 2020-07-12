/*
Parameter to be read from user input
*/

ids = ['ERR908507']

params.ncbiKey= ''

cacheOption=true
    
  
  
Channel
    .fromSRA(ids, cache: cacheOption, apiKey=ncbiKey)
    .into {ch_rclone_in}

/*
=======================
use rclone to upload these files
=======================
*/

process rclone {
    input:
    set genomeName, file(genomeReads) from ch_rclone_in

    output:
    set file(genomeReads) into ch_deleteLocalFiles_in

    script:

    """
    rclone copy ${genomeReads[0]} dropbox-shruti:/ncbi_to_dropbox  -L
    rclone copy ${genomeReads[1]} dropbox-shruti:/ncbi_to_dropbox  -L
    """   

}

/*
================
delete local files
===============
*/

process deleteLocalFiles {

    input:
    tuple genomeReads1, genomeReads2 from ch_deleteLocalFiles_in

    script:

    """
    rm \$(readlink -f ${genomeReads1}) \$(readlink -f ${genomeReads2})
    """   

}


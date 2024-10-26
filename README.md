# SHA256-Functional-Verification-with-UVM
A Repository about SHA256 Functional Verification using UVM, first UVM i used direct value from references to verify Single Message Block case and Double Message Block case. Its a simple UVM with predefined output. Second UVM is more advanced, sequence_item can generate random 512 bits input same as SHA256 theory(Preprocessing) automatically. The reference model also read the input message block from UVM_sequence_item and generate hash values, after that Scoreboard will read hash values which were generated from reference model and compare with the hash value of the DUT. There is a disadvantage with my second UVM is: It can only generated and drive Single Messsage Block so in that case my code coverage wont have a good coverage result than UVM used direct value.
references:
+ FIPS 180-2, Secure Hash Standard:
https://csrc.nist.gov/files/pubs/fips/180-2/upd1/final/docs/fips180-2withchangenotice.pdf
+ Verification of SHA-256 and MD5 Hash Functions Using UVM:
https://repository.rit.edu/cgi/viewcontent.cgi?article=11224&context=theses

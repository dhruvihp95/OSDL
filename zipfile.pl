# Create a Zip file
   use strict;
   use warnings;
   use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
   
   # Create new zip file
   my $zip = Archive::Zip->new();
   my $chunkSize = Archive::Zip::chunkSize();
   print "Chunk size = $chunkSize\n";
   # Add a directory
   my $dir_member = $zip->addFile( 'C:\\Users\\Darshil\\Documents\\Dhruvi\\OSDL\\PERL\\dirname\\demo.txt' );
   #my $subfile = $zip->addFile();
   # Add a file from a string with compression
   my $string_member = $zip->addString( 'This is a new test', 'stringMember.txt' ,9);
   $string_member->desiredCompressionMethod( COMPRESSION_DEFLATED );
   
   # Add a file from disk
   my $file_member = $zip->addFile( 'xyz.pl', 'AnotherName.pl' );
   $file_member->desiredCompressionLevel( COMPRESSION_LEVEL_DEFAULT );
   $file_member->desiredCompressionMethod( COMPRESSION_DEFLATED );
   my $file_member2 = $zip->addFile( 'ZipAnotherName.pl' );
   $file_member2->desiredCompressionLevel( COMPRESSION_LEVEL_DEFAULT );
   $file_member2->desiredCompressionMethod( COMPRESSION_DEFLATED );
   
   # Save the Zip file
   unless ( $zip->writeToFileNamed('C:\\Users\\Darshil\\Documents\\Dhruvi\\OSDL\\PERL\\someZip.zip') == AZ_OK ) {
       die 'write error';
   }

   # Read a Zip file
   my $somezip = Archive::Zip->new();
   unless ( $somezip->read( 'C:\\Users\\Darshil\\Documents\\Dhruvi\\OSDL\\PERL\\someZip.zip' ) == AZ_OK ) {
       die 'read error';
   }
   
   # Find all members of zip file
   my @members = $somezip->memberNames();
   my $no_members = $somezip->numberOfMembers();
   print "Number of members= $no_members \n";
   my $cnt = 0;
   for( $cnt=0;$cnt<$no_members;$cnt+=1){
      print "memeber $cnt name is ", $members[$cnt],"\n";
   }
   
   # Find a member with a particular name or regex
   my $member_name = "AnotherName.pl";
   my $find_member = $somezip->memberNamed($member_name);
   print "Found member: $find_member \n";
   my @text_file_members = $somezip->membersMatching( '.*\.txt' );
   print "Number of files with .txt: ",scalar @text_file_members,"\n";
   
   # Adding comment to zip file
   print "Old zip file comment:",$somezip->zipfileComment(),"\n";
   $somezip->zipfileComment( 'New Comment' );
   print "New zip file comment:",$somezip->zipfileComment(),"\n";
   
  
   # Extracting members of zip
   my $extract_member = $somezip->extractMemberWithoutPaths( 'AnotherName.pl' , 'ZipAnotherName.pl' );
   # Reading and Updating content of a zip file
   print "Old stringMember.txt contains " . $somezip->contents( 'stringMember.txt' ),"\n";
   $somezip->contents( 'stringMember.txt', 'This is the new contents' );
   print "New stringMember.txt contains " . $somezip->contents( 'stringMember.txt' ),"\n";   
   
   # Change the compression type for a file in the Zip
   my $member = $somezip->memberNamed( 'stringMember.txt' );
   #$member->desiredCompressionLevel( 9 );
   $member->desiredCompressionMethod( COMPRESSION_STORED );
   unless ( $zip->writeToFileNamed( 'someOtherZip.zip' ) == AZ_OK ) {
       die 'write error';
   }
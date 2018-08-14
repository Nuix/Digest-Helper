#This class wraps functionality related to reading a Nuix digest list
class NuixDigestListReader
	class << self
		#Convenience method which provides common digests directory path
		def digests_directory
			return File.join(java.lang.System.getenv("APPDATA"),"Nuix","Digest Lists")
		end

		#Provides likely path to Nuix digest list file based on name
		def get_digest_path(name)
			return "#{digests_directory}\\#{name}.hash"
		end

		#Iterates each MD5 entry (as a hex string) in the provided Nuix digest file
		def each_digest_string(file,&block)
			File.open(file,"rb") do |file|
				#Read off header
				file.read(13)
				#Read md5 values
				while md5_bytes = file.read(16)
					yield(binary_to_md5(md5_bytes))
				end
			end
		end

		#Converts the digest list with the provided name to a text file
		#saved at the profile file path
		def convert_to_text_file(name,destination_file)
			digest_file = get_digest_path(name)
			if !java.io.File.new(digest_file).exists
				raise "Could not locate digest file for '#{name}'"
			end
			#Create output directories as needed
			java.io.File.new(destination_file).getParentFile.mkdirs
			File.open(destination_file,"w") do |file|
				each_digest_string(digest_file) do |md5|
					file.puts(md5)
				end
			end
		end

		#Converts bytes to hex string
		def binary_to_md5(md5_bytes)
			return md5_bytes.unpack('H*')[0]
		end
	end
end

#The digest list name (as seen in Nuix)
digest_name = "DontProcess"

#Resolve digest list name to actual digest file
digest_path = NuixDigestListReader.get_digest_path(digest_name)

#Iterate each digest value (as hex string!), this is just to demonstrate iterating a digest list
NuixDigestListReader.each_digest_string(digest_path) do |md5|
	puts "MD5 = #{md5}" #Likely you would do something more useful here
end

#Method for converting to a text file
text_file_path = "C:\\temp\\DontProcess_MD5s.txt"
NuixDigestListReader.convert_to_text_file(digest_name,text_file_path)
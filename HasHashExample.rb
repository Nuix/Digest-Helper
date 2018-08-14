script_directory = File.dirname(__FILE__)
load File.join(script_directory,"DigestHelper.rb_")

case_directory = "C:\\@Nuix\\Cases\\Mega Computer Image"
db_file = File.join(case_directory,"Hashes.db").gsub("/","\\")

puts "Opening case..."
$current_case = $utilities.getCaseFactory.open(case_directory)

digest_helper = DigestHelper.new(db_file)

puts "Searching..."
items = $current_case.search("md5:*",{:limit=>5000000})

puts "Adding hashes..."
digest_helper.add(items) do |commit_count|
	puts "Hashes Commit: #{commit_count}"
end

puts "Total Hashes in DB: #{digest_helper.size}"

puts "Checking for hash presence..."
items.take(100).each do |item|
	md5 = item.getDigests.getMd5
	puts "Has Hash '#{md5}': #{digest_helper.has_hash(md5)}"
end

md5 = "SHOULD_NOT_BE_PRESENT"
puts "Has Hash '#{md5}': #{digest_helper.has_hash(md5)}"

$current_case.close
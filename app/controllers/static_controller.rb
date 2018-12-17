class StaticController < ApplicationController
	def home
		@data = Dir.glob("#{Rails.root}/public/data/**")

		@data.each do |dir|
			@user = User.new		
			user_name = File.basename(dir)
			infos = Dir.glob("#{Rails.root}/public/data/#{user_name}/**")
			email = ''
			phone = ''
			infos.each do |info|
				if File.file?(info)
					email_phone = file_read(info)
					unless email_phone.first.nil?
						email = email_phone.first
						phone = email_phone.last
					end
				end				
			end
			@user.first = user_name.split(' ', 2)[0]
			@user.last = user_name.split(' ', 2)[1]
			@user.email = email
			@user.phone = phone
			@user.save 
			puts "******* #{user_name} saved..."
		end

		@users = User.all
	end

	def export
	  @users =  User.all

	  respond_to do |format|
	    format.html
	    format.xlsx
	  end
	end

	def file_read(file)
		puts "################## Read #{file}...."
		yomu = Yomu.new file
		contents = yomu.text
		email = extract_emails_to_array(contents).first
		unless email.nil?
			# contents.gsub!(/[().-\s+]/, '')
			phone = extract_phonenumber_to_array(contents)
		end
		return [ email, phone]
	end

	def extract_emails_to_array(txt)
	  reg = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
	  txt.scan(reg).uniq
	end

	def extract_phonenumber_to_array(txt)
		reg = /\d+.\d+.\d+/
		phone = ''
		txt.scan(/\d+.\d+.\d+/).each do |s| 
			t = s.gsub(/\D+/, '') 
			if (9..12).cover? t.length
				phone = t
				break
			end 
		end
		phone
	end
end

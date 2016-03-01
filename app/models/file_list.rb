class FileList < ActiveRecord::Base

  belongs_to :branch


  # create a new file listing as per directory structure
  def self.create_file_lists files
    ActiveRecord::Base.connection_pool.with_connection do
      FileList.transaction do
        FileList.create(files)
      end
    end
  end


  def self.get_file_lists branch
    ActiveRecord::Base.connection_pool.with_connection do
      FileList.where(:branch_id => branch.id, :status => 1)
    end
  end


  def self.update_files_status files
    ActiveRecord::Base.connection_pool.with_connection do
      FileList.transaction do
        files.update_all(status: 0)
      end
    end
  end

end

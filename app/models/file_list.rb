class FileList < ActiveRecord::Base

  has_many :code_issues
  belongs_to :branch
  belongs_to :supported_language


  # create a new file listing as per directory structure
  def self.create_file_lists files
    return if files.empty?
    ActiveRecord::Base.connection_pool.with_connection do
      FileList.transaction do
        FileList.create(files)
      end
    end
  end


  def self.get_file_lists branch
    ActiveRecord::Base.connection_pool.with_connection do
      FileList.where(branch_id: branch.id, status: 1)
    end
  end


  def self.get_files_to_process branch
    ActiveRecord::Base.connection_pool.with_connection do
      FileList.where(branch_id: branch.id, is_excluded: 0, is_file: 1, status: 1)
    end
  end


  def self.update_files_status files
    return if files.empty?
    ActiveRecord::Base.connection_pool.with_connection do
      FileList.transaction do
        files.each do |file|
          file.status = 0
          file.is_excluded = 0
          file.save!
        end
      end
    end
  end


  def self.update_score file, score
    ActiveRecord::Base.connection_pool.with_connection do
      FileList.transaction do
        file.update(gpa: score)
      end
    end
  end

end

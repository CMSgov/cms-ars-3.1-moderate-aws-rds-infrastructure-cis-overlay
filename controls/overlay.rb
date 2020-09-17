# encoding: utf-8

include_controls 'aws-rds-infrastructure-cis-baseline' do
  control 'aws-rds-baseline-4' do
  desc 'rationale', 'Provides a managed backup function of the RDS Database, it 
       is possible to define the backup window and retention period of the backup. 
       Each customer should have a retention policy set for the type of data being 
       stored. Recommend setting this to at least 3'
  tag 'check', 'Using the Amazon unified command line interface:
       * Check if your application DB instances have a Backup Retention Period set 
       (3 = there are 3 daily backups retained):

       aws rds describe-db-instances --filters
       Name=tag:<data_tier_tag>,Values=<data_tier_tag_value> --query
       \'DBInstances[*].{BackupRetentionPeriod:BackupRetentionPeriod,
       DBInstanceIdentifier:DBInstanceIdentifier}\''
  tag 'fix', 'Using the Amazon unified command line interface:
       * Modify each DB instance with Backup Retention Period of 0, and set a 
       desired Backup Retention Period in days (recommended value = 3):

       aws rds modify-db-instance --db-instance-identifier <your_db_instance>
       --backup- retention-period <backup_retention_period>'
  input('db_instance_identifier').each do |identifier|
    describe aws_rds_instance(identifier.to_s) do
      its('backup_retention_period') { should cmp >= 3 }
    end
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# IssueCategory -> seed
issue_category_data = [
  { name: 'style', description: 'The coding standard issues in your code.' },
  { name: 'complexity', description: 'The complexity of your code.' },
  { name: 'clarity', description: 'The clarity and understandability of your code.' },
  { name: 'compatibility', description: 'The compatibility of your code within modules.' },
  { name: 'security', description: 'The security vulnerabilities in your code.' },
  { name: 'bug risk', description: 'The possible bug risks in your code.' }
]

IssueCategory.create(issue_category_data)
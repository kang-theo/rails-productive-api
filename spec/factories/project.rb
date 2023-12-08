# Assuming you have FactoryBot configured
# class ProjectClass
#   attr_accessor :id, :name, :number, :project_number, :project_type_id, :project_color_id, 
#                 :last_activity_at, :public_access, :time_on_tasks, :tag_colors, :archived_at,
#                 :created_at, :template, :budget_closing_date, :needs_invoicing, :custom_fields,
#                 :task_custom_fields_ids, :sample_data, :organization_id, :company_id,
#                 :project_manager_id, :last_actor_id, :workflow_id, :membership_ids

#   def initialize(attributes = {})
#     attributes.each do |key, value|
#       send("#{key}=", value)
#     end
#   end

#   def with_archived_at(archived_at)
#     self.archived_at = archived_at
#     self
#   end
# end

# FactoryBot.define do
#   factory :project, class: Productive::Project do
#   # factory :project, class: ProjectClass do
#     attributes = { 
#       id: '399821',
#       name: 'create 1',
#       number: '14',
#       project_number: '14',
#       project_type_id: 1,
#       project_color_id: nil,
#       last_activity_at: '2023-11-28T04:33:37.000+01:00',
#       public_access: false,
#       time_on_tasks: false,
#       tag_colors: {},
#       archived_at: nil,
#       created_at: '2023-11-28T04:33:36.871+01:00',
#       template: false,
#       budget_closing_date: nil,
#       needs_invoicing: false,
#       custom_fields: nil,
#       task_custom_fields_ids: nil,
#       sample_data: false,
#       organization_id: '31810',
#       company_id: '699398',
#       project_manager_id: '561888',
#       last_actor_id: '561886',
#       workflow_id: '32544',
#       membership_ids: ['6368525', '6368526']
#     }

#     # Project is not a model, so we need to specify to use method new to instantiat
#     initialize_with { new(attributes) }
#     # used for creating a archived project
#     trait :with_archived_at do
#       archived_at { '2023-12-01T12:00:00.000+01:00' }
#     end
#   end
# end

FactoryBot.define do
  factory :project, class: Productive::Project do
    attributes = { 
      id: Faker::Number.unique.number(digits: 6),
      name: Faker::Lorem.words(number: 2).join(' '),
      number: Faker::Number.unique.number(digits: 2),
      project_number: Faker::Number.unique.number(digits: 2),
      project_type_id: Faker::Number.unique.number(digits: 1),
      project_color_id: nil,
      last_activity_at: Faker::Time.between(from: DateTime.now - 30, to: DateTime.now),
      public_access: Faker::Boolean.boolean,
      time_on_tasks: Faker::Boolean.boolean,
      tag_colors: {},
      archived_at: nil,
      created_at: Faker::Time.between(from: DateTime.now - 30, to: DateTime.now),
      template: Faker::Boolean.boolean,
      budget_closing_date: nil,
      needs_invoicing: Faker::Boolean.boolean,
      custom_fields: nil,
      task_custom_fields_ids: nil,
      sample_data: Faker::Boolean.boolean,
      organization_id: Faker::Number.unique.number(digits: 5),
      company_id: Faker::Number.unique.number(digits: 6),
      project_manager_id: Faker::Number.unique.number(digits: 6),
      last_actor_id: Faker::Number.unique.number(digits: 6),
      workflow_id: Faker::Number.unique.number(digits: 5),
      membership_ids: [Faker::Number.unique.number(digits: 7).to_s, Faker::Number.unique.number(digits: 7).to_s]
    }

    initialize_with { new(attributes) }

    trait :with_archived_at do
      archived_at { Faker::Time.between(from: DateTime.now - 30, to: DateTime.now) }
    end
  end
end

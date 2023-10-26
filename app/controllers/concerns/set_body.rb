module SetBody
  extend ActiveSupport::Concern

  # can integrate the set_xx methods to Projects module
  #TODO: need to fill info dynamically, 
  #TODO: for instance, providing a list of relationships for users to create a new project
  def set_body (body)
    body
  end
end

def create_body 
{
  "data": {
    "type": "projects",
    "attributes": {
      "name": "post_proj1",
      "project_type_id": 2
    },
    "relationships": {
      "company": {
        "data": {
          "type": "companies",
          "id": "602830"
        }
      },
      "project_manager": {
        "data": {
          "type": "people",
          "id": "521440"
        }
      },
      "workflow": {
        "data": {
          "type": "workflows",
          "id": "31589"
        }
      }
    }
  }
}
end

def update_body
{
  "data": {
    "type": "projects",
    "attributes": {
      "name": "update_proj1"
    }
  }
}
end

def archive_body
{
    "data": {
        "id": "384852",
        "type": "projects",
        "attributes": {
            "name": "post_proj5",
            "number": "9",
            "project_number": "9",
            "project_type_id": 2,
            "project_color_id": null,
            "last_activity_at": "2023-10-26T09:13:54.000+02:00",
            "public_access": false,
            "time_on_tasks": false,
            "tag_colors": {},
            "archived_at": null,
            "created_at": "2023-10-26T09:13:54.587+02:00",
            "template": false,
            "budget_closing_date": null,
            "needs_invoicing": false,
            "custom_fields": null,
            "task_custom_fields_ids": null,
            "sample_data": false
        },
        "relationships": {
            "organization": {
                "data": {
                    "type": "organizations",
                    "id": "30897"
                }
            },
            "company": {
                "data": {
                    "type": "companies",
                    "id": "596918"
                }
            },
            "project_manager": {
                "data": {
                    "type": "people",
                    "id": "515687"
                }
            },
            "last_actor": {
                "data": {
                    "type": "people",
                    "id": "515687"
                }
            },
            "workflow": {
                "data": {
                    "type": "workflows",
                    "id": "31524"
                }
            },
            "custom_field_people": {
                "data": []
            },
            "memberships": {
                "data": [
                    {
                        "type": "memberships",
                        "id": "6099648"
                    }
                ]
            },
            "template_object": {
                "data": null
            }
        }
    },
    "included": [
        {
            "id": "596918",
            "type": "companies",
            "attributes": {
                "name": "Company A [SAMPLE]",
                "billing_name": "Company A [SAMPLE]",
                "vat": "0000",
                "default_currency": null,
                "created_at": "2023-10-25T08:22:00.499+02:00",
                "last_activity_at": "2023-10-25T08:22:10.371+02:00",
                "archived_at": null,
                "avatar_url": null,
                "invoice_email_recipients": {},
                "custom_fields": null,
                "company_code": "COMP",
                "domain": null,
                "projectless_budgets": false,
                "description": null,
                "due_days": 25,
                "tag_list": [],
                "contact": {
                    "phones": [
                        {
                            "name": "Work",
                            "phone": "3345689873",
                            "contact_datum_id": 1618494
                        }
                    ],
                    "websites": [
                        {
                            "name": "Work",
                            "website": "https://www.best-airlinecom",
                            "contact_datum_id": 1618497
                        }
                    ],
                    "addresses": [
                        {
                            "city": "Madrid",
                            "name": "Billing",
                            "state": "",
                            "address": "Gran Via 34",
                            "country": "Spain",
                            "zipcode": "28001",
                            "billing_address": true,
                            "contact_datum_id": 1618500
                        }
                    ]
                },
                "sample_data": true,
                "settings": {},
                "external_id": null,
                "external_sync": false
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                },
                "custom_field_people": {
                    "data": []
                }
            }
        },
        {
            "id": "515687",
            "type": "people",
            "attributes": {
                "avatar_url": null,
                "deactivated_at": null,
                "first_name": "Kiwijason",
                "last_name": "Kang",
                "nickname": null,
                "role_id": 1,
                "email": "kiwijason.kang@gmail.com",
                "title": null,
                "contact": {},
                "status_emoji": null,
                "status_expires_at": null,
                "status_text": null,
                "joined_at": "2023-10-25T08:22:27.000+02:00",
                "last_seen_at": "2023-10-26T08:59:24.446+02:00",
                "archived_at": null,
                "invited_at": null,
                "is_user": true,
                "user_id": 120979,
                "tag_list": [],
                "virtual": false,
                "custom_fields": null,
                "autotracking": false,
                "created_at": "2023-10-25T08:21:53.967+02:00",
                "placeholder": false,
                "color_id": null,
                "sample_data": false,
                "time_unlocked": false,
                "time_unlocked_on": null,
                "time_unlocked_start_date": null,
                "time_unlocked_end_date": null,
                "time_unlocked_period_id": null,
                "time_unlocked_interval": null,
                "last_activity_at": "2023-10-25T08:21:54.223+02:00",
                "two_factor_auth": false,
                "availabilities": "[]",
                "external_id": null,
                "external_sync": false
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                },
                "manager": {
                    "meta": {
                        "included": false
                    }
                },
                "company": {
                    "data": {
                        "type": "companies",
                        "id": "596916"
                    }
                },
                "subsidiary": {
                    "data": {
                        "type": "subsidiaries",
                        "id": "32347"
                    }
                },
                "holiday_calendar": {
                    "data": {
                        "type": "holiday_calendars",
                        "id": "31512"
                    }
                },
                "custom_role": {
                    "data": {
                        "type": "roles",
                        "id": "418670"
                    }
                },
                "custom_field_people": {
                    "data": []
                },
                "teams": {
                    "data": []
                }
            }
        },
        {
            "id": "31524",
            "type": "workflows",
            "attributes": {
                "name": "Default workflow",
                "archived_at": null
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                },
                "workflow_statuses": {
                    "data": [
                        {
                            "type": "workflow_statuses",
                            "id": "89394"
                        },
                        {
                            "type": "workflow_statuses",
                            "id": "89395"
                        }
                    ]
                }
            }
        },
        {
            "id": "6099648",
            "type": "memberships",
            "attributes": {
                "access_type_id": 5,
                "dynamic_group_id": null,
                "options": {},
                "target_type": "project",
                "type_id": 1
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                },
                "person": {
                    "data": {
                        "type": "people",
                        "id": "515687"
                    }
                },
                "team": {
                    "data": null
                },
                "dashboard": {
                    "meta": {
                        "included": false
                    }
                },
                "deal": {
                    "meta": {
                        "included": false
                    }
                },
                "filter": {
                    "meta": {
                        "included": false
                    }
                },
                "page": {
                    "meta": {
                        "included": false
                    }
                },
                "project": {
                    "data": {
                        "type": "projects",
                        "id": "384852"
                    }
                }
            }
        },
        {
            "id": "596916",
            "type": "companies",
            "attributes": {
                "name": "pixelforce",
                "billing_name": null,
                "vat": null,
                "default_currency": "AUD",
                "created_at": "2023-10-25T08:21:53.934+02:00",
                "last_activity_at": "2023-10-25T08:21:53.934+02:00",
                "archived_at": null,
                "avatar_url": null,
                "invoice_email_recipients": {},
                "custom_fields": null,
                "company_code": "PIXE",
                "domain": null,
                "projectless_budgets": false,
                "description": null,
                "due_days": null,
                "tag_list": [],
                "contact": {},
                "sample_data": false,
                "settings": {},
                "external_id": null,
                "external_sync": false
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                },
                "custom_field_people": {
                    "data": []
                }
            }
        },
        {
            "id": "32347",
            "type": "subsidiaries",
            "attributes": {
                "name": "pixelforce",
                "invoice_number_format": null,
                "invoice_number_scope": null,
                "archived_at": null,
                "overhead_per_subsidiary": null,
                "overhead_amortization_period": null,
                "overhead_recalculation_day": null,
                "show_delivery_date": false,
                "export_integration_type_id": null,
                "invoice_logo_url": null,
                "facility_costs": 0,
                "facility_costs_default": 0,
                "facility_costs_normalized": 0
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                },
                "bill_from": {
                    "data": {
                        "type": "contact_entries",
                        "id": "1618492"
                    }
                },
                "integration": {
                    "data": null
                }
            }
        },
        {
            "id": "31512",
            "type": "holiday_calendars",
            "attributes": {
                "name": "Australia",
                "country": "Australia",
                "state": null,
                "autogenerate_holidays": true
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                }
            }
        },
        {
            "id": "418670",
            "type": "roles",
            "attributes": {
                "base_role_id": 1,
                "description": "Administrators can manage everything, including creating user accounts, managing salaries, and general organization-level settings. Note that some of the things could be hidden from the administrator due to additional sharing functionality.",
                "name": "Admin",
                "people_count": 1,
                "permissions": {},
                "editable_by_user": false,
                "user_type_id": 1
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                }
            }
        },
        {
            "id": "89394",
            "type": "workflow_statuses",
            "attributes": {
                "name": "Open",
                "color_id": 11,
                "position": 1,
                "category_id": 2
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                },
                "workflow": {
                    "data": {
                        "type": "workflows",
                        "id": "31524"
                    }
                }
            }
        },
        {
            "id": "89395",
            "type": "workflow_statuses",
            "attributes": {
                "name": "Closed",
                "color_id": 14,
                "position": 2,
                "category_id": 3
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                },
                "workflow": {
                    "data": {
                        "type": "workflows",
                        "id": "31524"
                    }
                }
            }
        },
        {
            "id": "1618492",
            "type": "contact_entries",
            "attributes": {
                "contactable_type": "subsidiary",
                "type": "bill_from",
                "name": "pixelforce",
                "email": null,
                "phone": null,
                "website": null,
                "address": null,
                "city": null,
                "state": null,
                "zipcode": null,
                "country": "Australia",
                "vat": null,
                "billing_address": null
            },
            "relationships": {
                "organization": {
                    "data": {
                        "type": "organizations",
                        "id": "30897"
                    }
                },
                "company": {
                    "data": null
                },
                "person": {
                    "data": null
                },
                "invoice": {
                    "data": null
                },
                "subsidiary": {
                    "data": {
                        "type": "subsidiaries",
                        "id": "32347"
                    }
                },
                "purchase_order": {
                    "data": null
                }
            }
        }
    ],
    "meta": {
        "organization_features": {
            "custom_fields": {
                "type": "metered",
                "limit": 15
            },
            "custom_fields_per_project": {
                "type": "metered",
                "limit": 10
            },
            "public_custom_reports": {
                "type": "metered",
                "limit": 1000
            },
            "private_custom_reports": {
                "type": "metered",
                "limit": 1000
            },
            "public_project_reports": {
                "type": "metered",
                "limit": 1000
            },
            "private_project_reports": {
                "type": "metered",
                "limit": 1000
            },
            "scheduling_placeholders": {
                "type": "metered",
                "limit": 10
            },
            "workflows": {
                "type": "metered",
                "limit": 10
            },
            "rate_cards": {
                "type": "metered",
                "limit": 30
            },
            "teams": {
                "type": "metered",
                "limit": 20
            },
            "outgoing_emails": {
                "type": "metered",
                "limit": 100
            },
            "recycle_bin": {
                "type": "restricted",
                "available": true,
                "limit": 730
            },
            "multigrouping": {
                "type": "switch",
                "available": true
            },
            "client_access_to_budgets": {
                "type": "switch",
                "available": true
            },
            "subsidiaries": {
                "type": "switch",
                "available": true
            },
            "time_approvals": {
                "type": "switch",
                "available": true
            },
            "expenses_approvals": {
                "type": "switch",
                "available": true
            },
            "timeoff_approvals": {
                "type": "switch",
                "available": true
            },
            "autotracking": {
                "type": "switch",
                "available": true
            },
            "forecasting": {
                "type": "switch",
                "available": true
            },
            "webhooks": {
                "type": "switch",
                "available": true
            },
            "table_pivoting": {
                "type": "switch",
                "available": true
            },
            "formula_fields": {
                "type": "switch",
                "available": true
            },
            "single_sign_on": {
                "type": "switch",
                "available": true
            },
            "duplicate_tasks": {
                "type": "switch",
                "available": true
            },
            "billable_time_rounding": {
                "type": "switch",
                "available": true
            },
            "payment_sync": {
                "type": "switch",
                "available": true
            },
            "booking_methods": {
                "type": "switch",
                "available": true
            },
            "import_tasks_csv": {
                "type": "switch",
                "available": true
            },
            "reactions": {
                "type": "switch",
                "available": true
            },
            "time_week_view": {
                "type": "switch",
                "available": true
            },
            "subtasks": {
                "type": "switch",
                "available": true
            },
            "time_calendar_layout": {
                "type": "switch",
                "available": true
            },
            "theming": {
                "type": "switch",
                "available": true
            },
            "remove_branding": {
                "type": "switch",
                "available": true
            },
            "custom_invoicing_email": {
                "type": "switch",
                "available": true
            },
            "google_calendar_layout": {
                "type": "switch",
                "available": true
            },
            "pulse": {
                "type": "switch",
                "available": true
            },
            "slack": {
                "type": "switch",
                "available": true
            },
            "task_custom_fields_library": {
                "type": "switch",
                "available": true
            },
            "timeline_layout": {
                "type": "switch",
                "available": true
            },
            "comment_visibility": {
                "type": "switch",
                "available": true
            },
            "time_off_sync": {
                "type": "switch",
                "available": true
            },
            "time_locking": {
                "type": "switch",
                "available": true
            },
            "docs": {
                "type": "switch",
                "available": true
            },
            "scheduling_resource_utilization": {
                "type": "switch",
                "available": true
            },
            "enforce_two_factor_auth": {
                "type": "switch",
                "available": true
            },
            "personio_integration": {
                "type": "switch",
                "available": true
            },
            "task_dependencies": {
                "type": "switch",
                "available": true
            },
            "hris_integration": {
                "type": "switch",
                "available": true
            },
            "numbering_scheme": {
                "type": "switch",
                "available": true
            },
            "automations": {
                "type": "restricted",
                "available": true,
                "limit": 25000
            },
            "dashboards_sharing": {
                "type": "switch",
                "available": true
            },
            "currency_picker": {
                "type": "switch",
                "available": true
            },
            "required_custom_fields": {
                "type": "switch",
                "available": true
            },
            "restricted_tracking": {
                "type": "switch",
                "available": true
            },
            "enforce_sso": {
                "type": "switch",
                "available": true
            },
            "jira_integration": {
                "type": "switch",
                "available": true
            },
            "docs_versions": {
                "type": "switch",
                "available": true
            },
            "zapier_integration": {
                "type": "switch",
                "available": true
            },
            "recurring_budgets": {
                "type": "switch",
                "available": true
            },
            "restricted_user_roles": {
                "type": "switch",
                "available": true
            },
            "service_tracking_toggle": {
                "type": "switch",
                "available": true
            },
            "repeating_tasks": {
                "type": "switch",
                "available": true
            },
            "save_public_and_private_view": {
                "type": "switch",
                "available": true
            },
            "overhead_cost": {
                "type": "switch",
                "available": true
            },
            "show_only_filtered_data": {
                "type": "switch",
                "available": true
            },
            "invoicing_integrations": {
                "type": "switch",
                "available": true
            },
            "audit_log": {
                "type": "switch",
                "available": true
            },
            "hubspot_integration": {
                "type": "switch",
                "available": true
            },
            "booking_activity_modal": {
                "type": "switch",
                "available": true
            },
            "person_custom_field": {
                "type": "switch",
                "available": true
            },
            "template_center": {
                "type": "switch",
                "available": true
            },
            "custom_roles": {
                "type": "switch",
                "available": true
            },
            "purchase_orders": {
                "type": "switch",
                "available": true
            },
            "payment_reminders": {
                "type": "switch",
                "available": true
            },
            "gantt": {
                "type": "switch",
                "available": true
            },
            "tentative_bookings": {
                "type": "switch",
                "available": true
            },
            "task_view_sharing": {
                "type": "switch",
                "available": true
            }
        },
        "settings": {
            "systemFlags": {
                "setting_type": "systemFlags",
                "value": "[\"alternativeQuickSearchShortcut\",\"alwaysEnableLimitedTimeOffs\",\"amplitudeMtuOptimization\",\"apiAttributesOnlyCache\",\"apiRemoveOrganizationMembershipTimer\",\"auditLog\",\"billingTypeFinancialInsight\",\"boardPickerAddNewList\",\"bookingFormNestedServicePicker\",\"bookingRequiredCustomField\",\"bookingSplitApiAction\",\"bookingsUseDealAcl\",\"breathe\",\"budgetActualCap\",\"budgetAddNewMembers\",\"budgetDefaultsSettings\",\"budgetMemberships\",\"budgetRecurringFieldInsight\",\"budgetRecurringFilters\",\"budgetSchedulingControl\",\"budgetServicesRevamp\",\"bulkMoveBookings\",\"bulkShiftAndExtendDates\",\"calendarDuplicateTimeEntry\",\"capacityAvailabilityScheduledBillable\",\"convertToDoc\",\"convertToVirtualUser\",\"copierAsCreator\",\"coreCheckUpdatedAtInPushInternalModel\",\"costRateHolidayCalendar\",\"dashboards_revamp\",\"dateRangeFieldOnTasksView\",\"dayEntriesMobileDrawer\",\"dayViewDuplicate\",\"dayViewPin\",\"deprecateOldTimeReport\",\"docs\",\"docsAccessibleDocIdFilter\",\"docsBannersInToolbar\",\"docsBreadcrumbsRevamp\",\"docsChecklist\",\"docsComments\",\"docsCreateTask\",\"docsCursorNameFlags\",\"docsExportAsPdf\",\"docsFileUpload\",\"docsMovePage\",\"docsPageCoverEmoji\",\"docsPagePreferences\",\"docsPreventAddMembershipsOnProjectDoc\",\"docsRealtimeAuth\",\"docsSaveUntitledPages\",\"docsStepsOnSave\",\"docsTableUi\",\"docsVersionNumber\",\"documentDealJobs\",\"documentTemplateAttachments\",\"documentTemplateSorting\",\"documentTemplateWizard\",\"dueDateConfigurableOnNotifications\",\"duplicateAndArchiveRateCards\",\"duplicateFromLastWorkingDay\",\"duplicatePageDoc\",\"economicCustomer\",\"emptyChangesetOnDestroyActivity\",\"enableTimeOff\",\"exactPaymentSync\",\"exactUpdateInvoice\",\"expenseApprovalsNotification\",\"expenseQuantity\",\"expensesCurrencyCalculation\",\"expensesDifferentCurrenciesMarkup\",\"exportCreditNoteEconomic\",\"exportCreditNoteExact\",\"exportCreditNoteFortnox\",\"facilityCostsRate\",\"financialReportTimeFields\",\"financialsRevamp\",\"formulableProbability\",\"fortnoxUpdateInvoice\",\"freeForNowIntegrationBadge\",\"headerActionsInSidebar\",\"hideDocumentTemplateFields\",\"hideUserContactsFromClients\",\"hourlyCostRate\",\"hubspot\",\"importTemplatesNewDesign\",\"invoiceLineItemsReports\",\"invoicePercentageOfBudget\",\"invoiceWizardNewBudgetsTable\",\"invoiceWizardUnrecognizedCorrection\",\"jiraIssueStatusAndSummary\",\"jumpSearchQuickSearch\",\"mailerOutboxFromDomain\",\"manualBudgetRecurring\",\"marketplaceBanner\",\"meilisearchReindex\",\"membershipFirstLevelIncludes\",\"membershipsOnProjects\",\"milestones\",\"navGenericRendering\",\"navigationByModule\",\"nestedExpenseOptions\",\"newAddonsLocation\",\"newAvatarUploadFlow\",\"newAvatarUploadFlowForPerson\",\"newBookingSynchronizerJob\",\"newEssentialPlan\",\"newExpenseForm\",\"newProjectWizard\",\"newSalaryTable\",\"nonWorkingDaysColor\",\"normalizedCurrencyInReports\",\"numberingSchemeFormatting\",\"organizationMembershipWithoutCounts\",\"overheadCostAddonSettings\",\"overheadTimeOffCosts\",\"overheadValidation\",\"patchSave\",\"paymentRemindersFlag\",\"payrollReport\",\"personAvailabilities\",\"personCustomField\",\"personNicknameCustomization\",\"personalIntegrations\",\"popoverContentImprovement\",\"pricesReport\",\"projectTemplates\",\"projectlessBudget\",\"purchaseOrders\",\"pushInternalModelOverride\",\"ratesInEuroColumn\",\"recalculateOverheadOnProjections\",\"relationshipFields\",\"removeBreatheIntegrationFromMergeDev\",\"resourcingEnableDragWhileUndoing\",\"resourcingNavigationItems\",\"schedulingCompanyFilter\",\"schedulingHalfDayBooking\",\"schedulingHistory\",\"schedulingPercentageOnEventBookings\",\"searchDocsMentionsNoCount\",\"servicePickerExtendedScope\",\"servicePickerMembershipsScope\",\"servicesViewSetupQuantity\",\"slackMobileGranularNotifications\",\"taskAttachmentsRedesign\",\"taskSubscribersEndpoint\",\"tasksInlineEdit\",\"teams\",\"templateProjectsPolicyRevamp\",\"timeCalendarRevamp\",\"timeEntryCostRateCurrency\",\"timeEntryImport\",\"timeLockingByDay\",\"toDoDueDateConfigurableOnNotifications\",\"twinfieldIntegration\",\"unlimitedTimeOffsInHours\",\"useNormalizedCurrencyForLineItems\",\"userCanChangeOwnEmail\",\"userImport\",\"webhooksRewrite\",\"weeklySummaryRevamp\",\"workLogOnMyTime\"]",
                "updated_at": "2023-10-25T09:03:51.829+02:00"
            }
        }
    }
}
end
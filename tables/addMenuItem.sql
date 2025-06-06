IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') AND type = N'U')
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'ISSO'
          AND menu_ParentId = 0
          AND menu_ToPage = '/Dashboard.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'ISSO',
            GETDATE(),
            0,
            '/Dashboard.aspx',
            'settings.png',
            '#6885a2',
            ' ',
            'report_status.png',
            17,
            'ISSO',
            NULL,
            NULL
        );
    END
END

IF EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'Visa Application'
          AND menu_ParentId = 2460
          AND menu_ToPage = 'ISSO/VisaApplication.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'Visa Application',
            GETDATE(),
            2460,
            'ISSO/VisaApplication.aspx',
            'settings.png',
            '#6885a2',
            ' ',
            'report_status.png',
            1,
            'Visa Application',
            NULL,
            NULL
        );
    END
END

IF EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'International Student List'
          AND menu_ParentId = 2454
          AND menu_ToPage = 'InternationalStudentList.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'International Student List',
            GETDATE(),
            2454,
            'InternationalStudentList.aspx',
            'settings.png',
            '#6885a2',
            ' ',
            'report_status.png',
            2,
            'InternationalStudentList',
            NULL,
            NULL
        );
    END
END


IF EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'ISSO Dashboard'
          AND menu_ParentId = 2453
          AND menu_ToPage = '/NewDashBoards/ISSODashboard.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'ISSO Dashboard',
            GETDATE(),
            2453,
            '/NewDashBoards/ISSODashboard.aspx',
            'd_icon3.png',
            '#025bac',
            ' ',
            'apprv.png ',
            2,
            'ISSO Dashboard',
            NULL,
            NULL
        );
    END
END

IF EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'Student Excel Upload'
          AND menu_ParentId = 45
          AND menu_ToPage = '/StudentExcel_Upload.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'Student Excel Upload',
            GETDATE(),
            45,
            '/StudentExcel_Upload.aspx',
            'Class_timings.png',
            '#025bac',
            ' ',
            'Class_timings.png',
            7,
            'Student Excel Upload',
            NULL,
            NULL
        );
    END
END

IF EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'Followup Status Master'
          AND menu_ParentId = 122
          AND menu_ToPage = '/FollowupStatusMaster.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'Followup Status Master',
            GETDATE(),
            122,
            '/FollowupStatusMaster.aspx',
            'enquiry_list.png',
            '#025bac',
            ' ',
            'enquiry_list.png',
            3,
            'Followup Status Master',
            NULL,
            NULL
        );
    END
END

IF EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'Lead Status Master'
          AND menu_ParentId = 122
          AND menu_ToPage = '/LeadStatus_MasterSettings.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'Lead Status Master',
            GETDATE(),
            122,
            '/LeadStatus_MasterSettings.aspx',
            'enquiry_list.png',
            '#025bac',
            ' ',
            'enquiry_list.png',
            3,
            'Lead Status Master',
            NULL,
            NULL
        );
    END
END


IF EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'Go to LMS'
          AND menu_ParentId = 2432
          AND menu_ToPage = 'Lms.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'Go to LMS',
            GETDATE(),
            2432,
            'Lms.aspx',
            'd_icon3.png',
            'Go to LMS',
            '',
            'user29.png',
            18,
            NULL,
            NULL,
            NULL
        );
    END
END

IF EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'Interest Level Master'
          AND menu_ParentId = 122
          AND menu_ToPage = '/Interest_Level_MasterSettings.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'Interest Level Master',
            GETDATE(),
            122,
            '/Interest_Level_MasterSettings.aspx',
            'enquiry_list.png',
            '#025bac',
            ' ',
            'enquiry_list.png',
            5,
            'Interest Level Master',
            NULL,
            NULL
        );
    END
END


IF EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu]
        WHERE menu_Name = 'Pipeline Master'
          AND menu_ParentId = 122
          AND menu_ToPage = '/PipelineSettingsMaster.aspx'
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            [menu_Name],
            [menu_dtTime],
            [menu_ParentId],
            [menu_ToPage],
            [menu_ImageName],
            [menu_color],
            [menu_description],
            [menu_SImage],
            [menu_DisplayOrder],
            [menu_tooltip],
            [menu_AndroidImage],
            [LeftPannelMenuForAndroit]
        )
        VALUES (
            'Pipeline Master',
            GETDATE(),
            122,
            '/PipelineSettingsMaster.aspx',
            'enquiry_list.png',
            '#025bac',
            ' ',
            'enquiry_list.png',
            6,
            'Pipeline Master Settings',
            NULL,
            NULL
        );
    END
END

IF EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Menu]') 
      AND type = N'U'
)
BEGIN
    -- Event List
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu] WHERE menu_Name = 'Event List' AND menu_ParentId = 19
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            menu_Name, menu_dtTime, menu_ParentId, menu_ToPage, menu_ImageName, menu_color,
            menu_description, menu_SImage, menu_DisplayOrder, menu_tooltip, menu_AndroidImage, LeftPannelMenuForAndroit
        )
        VALUES (
            'Event List', GETDATE(), 19, '/EventOrganising.aspx', 'prospect_list.png', '#025bac',
            'To List New Enquiries', 'prospect_list.png', 4, 'To List New Enquiries', NULL, NULL
        );
    END

    -- Event Approval
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu] WHERE menu_Name = 'Event Approval' AND menu_ParentId = 19
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            menu_Name, menu_dtTime, menu_ParentId, menu_ToPage, menu_ImageName, menu_color,
            menu_description, menu_SImage, menu_DisplayOrder, menu_tooltip, menu_AndroidImage, LeftPannelMenuForAndroit
        )
        VALUES (
            'Event Approval', GETDATE(), 19, '/councellorEventApproval.aspx', 'event_approval.png', '#025bac',
            '', 'generate_template.png', 3, 'Generate template', NULL, NULL
        );
    END

    -- Expense Approval
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu] WHERE menu_Name = 'Expense Approval' AND menu_ParentId = 19
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            menu_Name, menu_dtTime, menu_ParentId, menu_ToPage, menu_ImageName, menu_color,
            menu_description, menu_SImage, menu_DisplayOrder, menu_tooltip, menu_AndroidImage, LeftPannelMenuForAndroit
        )
        VALUES (
            'Expense Approval', GETDATE(), 19, '/BudgetApproval.aspx', 'expense_approval.png', '#025bac',
            '', 'generate_template.png', 3, 'Generate template', NULL, NULL
        );
    END

    -- Pso Event List
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu] WHERE menu_Name = 'Pso Event List' AND menu_ParentId = 19
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            menu_Name, menu_dtTime, menu_ParentId, menu_ToPage, menu_ImageName, menu_color,
            menu_description, menu_SImage, menu_DisplayOrder, menu_tooltip, menu_AndroidImage, LeftPannelMenuForAndroit
        )
        VALUES (
            'Pso Event List', GETDATE(), 19, '/PsoEventOrganisings.aspx', 'prospect_list.png', '#025bac',
            'Pso Event List', 'prospect_list.png', 4, 'To List New Enquiries', NULL, NULL
        );
    END

    -- Approved Event List
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[tbl_Menu] WHERE menu_Name = 'Approved Event List' AND menu_ParentId = 19
    )
    BEGIN
        INSERT INTO [dbo].[tbl_Menu] (
            menu_Name, menu_dtTime, menu_ParentId, menu_ToPage, menu_ImageName, menu_color,
            menu_description, menu_SImage, menu_DisplayOrder, menu_tooltip, menu_AndroidImage, LeftPannelMenuForAndroit
        )
        VALUES (
            'Approved Event List', GETDATE(), 19, '/EventApprovalList.aspx', 'prospect_list.png', '#025bac',
            'To List New Enquiries', 'prospect_list.png', 4, 'To List New Enquiries', NULL, NULL
        );
    END
END

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Pipeline'
      AND [menu_ParentId] = 23
      AND [menu_ToPage] = '/PipeLineManage.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu] 
        ([menu_Name], [menu_dtTime], [menu_ParentId], [menu_ToPage], [menu_ImageName], [menu_color], 
         [menu_description], [menu_SImage], [menu_DisplayOrder], [menu_tooltip], [menu_AndroidImage], [LeftPannelMenuForAndroit])
    VALUES 
        ('Pipeline', GETDATE(), 23, '/PipeLineManage.aspx', 'Mandatory72.png', '#6885a2', '', 'report_status.png', 17, 'PipeLine View', NULL, NULL);
END


IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Leads/Appication Statitics'
      AND [menu_ParentId] = 172
      AND [menu_ToPage] = '/LeadApplicationStatitics.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu] 
        ([menu_Name], [menu_dtTime], [menu_ParentId], [menu_ToPage], [menu_ImageName], [menu_color], 
         [menu_description], [menu_SImage], [menu_DisplayOrder], [menu_tooltip], [menu_AndroidImage], [LeftPannelMenuForAndroit])
    VALUES 
        ('Leads/Appication Statitics', GETDATE(), 172, '/LeadApplicationStatitics.aspx', 'report_status.png', '#025bac', ' ', 'report_status.png', 21, 'Leads/Appication Statitics', NULL, NULL);
END

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Modular Course'
      AND [menu_ParentId] = 2477
      AND [menu_ToPage] = '/Dashboard.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu]
       ([menu_Name]
       ,[menu_dtTime]
       ,[menu_ParentId]
       ,[menu_ToPage]
       ,[menu_ImageName]
       ,[menu_color]
       ,[menu_description]
       ,[menu_SImage]
       ,[menu_DisplayOrder]
       ,[menu_tooltip]
       ,[menu_AndroidImage]
       ,[LeftPannelMenuForAndroit])
    VALUES
       ('Modular Course',
       GETDATE(),
       2477,
       '/Dashboard.aspx',
       'settings.png',
       '#6885a2',
       ' ',
       'report_status.png',
       1,
       'Visa Application',
       NULL,
       NULL);
END

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Schedule Planning'
      AND [menu_ParentId] = 2477
      AND [menu_ToPage] = 'Modular_Course/SchedulePlanning.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu]
       ([menu_Name]
       ,[menu_dtTime]
       ,[menu_ParentId]
       ,[menu_ToPage]
       ,[menu_ImageName]
       ,[menu_color]
       ,[menu_description]
       ,[menu_SImage]
       ,[menu_DisplayOrder]
       ,[menu_tooltip]
       ,[menu_AndroidImage]
       ,[LeftPannelMenuForAndroit])
    VALUES
       ('Schedule Planning',
       GETDATE(),
       2477,
       'Modular_Course/SchedulePlanning.aspx',
       'settings.png',
       '#6885a2',
       ' ',
       'report_status.png',
       1,
       'SchedulePlanning',
       NULL,
       NULL);
END

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Modular Course List'
      AND [menu_ParentId] = 2477
      AND [menu_ToPage] = 'Modular_Course/ModularCourseList.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu]
       ([menu_Name]
       ,[menu_dtTime]
       ,[menu_ParentId]
       ,[menu_ToPage]
       ,[menu_ImageName]
       ,[menu_color]
       ,[menu_description]
       ,[menu_SImage]
       ,[menu_DisplayOrder]
       ,[menu_tooltip]
       ,[menu_AndroidImage]
       ,[LeftPannelMenuForAndroit])
    VALUES
       ('Modular Course List',
       GETDATE(),
       2477,
       'Modular_Course/ModularCourseList.aspx',
       'd_icon10.png',
       '#6885a2',
       ' ',
       'report_status.png',
       1,
       'Modular Course List',
       NULL,
       NULL);
END

-- Insert into tbl_Menu if not exists
IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Remark Settings'
      AND [menu_ParentId] = 2323
      AND [menu_ToPage] = '/ExamManagement/RemarkSettings.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu] 
        ([menu_Name], [menu_dtTime], [menu_ParentId], [menu_ToPage], [menu_ImageName], 
         [menu_color], [menu_description], [menu_SImage], [menu_DisplayOrder], [menu_tooltip], 
         [menu_AndroidImage], [LeftPannelMenuForAndroit])
    VALUES
        ('Remark Settings', GETDATE(), 2323, '/ExamManagement/RemarkSettings.aspx', 'exam_type_72.png', 
         '#6885a2', ' ', 'exam_type_18.png', 7, 'Remark Settings', NULL, NULL);
END

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Exam Type Master'
      AND [menu_ParentId] = 2323
      AND [menu_ToPage] = '/ExamManagement/ExamTypeMaster.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu]
           ([menu_Name]
           ,[menu_dtTime]
           ,[menu_ParentId]
           ,[menu_ToPage]
           ,[menu_ImageName]
           ,[menu_color]
           ,[menu_description]
           ,[menu_SImage]
           ,[menu_DisplayOrder]
           ,[menu_tooltip]
           ,[menu_AndroidImage]
           ,[LeftPannelMenuForAndroit])
     VALUES
           ('Exam Type Master'
           ,GETDATE()
           ,2323
           ,'/ExamManagement/ExamTypeMaster.aspx'
           ,'../img/report_Internal_Marks_72.png'
           ,'#6885a2'
           ,' '
           ,'exam_type_18.png'
           ,8
           ,'Exam Type Master'
           ,NULL
           ,NULL)
END

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Class Schedule with Student List'
      AND [menu_ParentId] = 2477
      AND [menu_ToPage] = 'Modular_Course/ModularClassSchedule.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu]
           ([menu_Name]
           ,[menu_dtTime]
           ,[menu_ParentId]
           ,[menu_ToPage]
           ,[menu_ImageName]
           ,[menu_color]
           ,[menu_description]
           ,[menu_SImage]
           ,[menu_DisplayOrder]
           ,[menu_tooltip]
           ,[menu_AndroidImage]
           ,[LeftPannelMenuForAndroit])
     VALUES
           ('Class Schedule with Student List',
           GETDATE(),
          2477,
           'Modular_Course/ModularClassSchedule.aspx',
           'd_icon10.png',
           '#6885a2',
           ' ',
           'enquiry_list.png',
           5,
           'Class Schedule with Student List',
           NULL,
           NULL)
END

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Modular Students List'
      AND [menu_ParentId] = 2477
      AND [menu_ToPage] = 'Modular_Course/Modular_Students_List.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu]
           ([menu_Name]
           ,[menu_dtTime]
           ,[menu_ParentId]
           ,[menu_ToPage]
           ,[menu_ImageName]
           ,[menu_color]
           ,[menu_description]
           ,[menu_SImage]
           ,[menu_DisplayOrder]
           ,[menu_tooltip]
           ,[menu_AndroidImage]
           ,[LeftPannelMenuForAndroit])
     VALUES
           ('Modular Students List',
           GETDATE(),
           2477,
           'Modular_Course/Modular_Students_List.aspx',
           'enquiry_list.png',
           '#6885a2',
           ' ',
           'enquiry_list.png',
           1,
           'Modular Students List',
           NULL,
           NULL)
END;

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Modular Course Application List'
      AND [menu_ParentId] = 2477
      AND [menu_ToPage] = 'Modular_Course/Modular_Application_List.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu]
           ([menu_Name]
           ,[menu_dtTime]
           ,[menu_ParentId]
           ,[menu_ToPage]
           ,[menu_ImageName]
           ,[menu_color]
           ,[menu_description]
           ,[menu_SImage]
           ,[menu_DisplayOrder]
           ,[menu_tooltip]
           ,[menu_AndroidImage]
           ,[LeftPannelMenuForAndroit])
     VALUES
           ('Modular Course Application List',
           GETDATE(),
           2477,
           'Modular_Course/Modular_Application_List.aspx',
           'enquiry_list.png',
           '#6885a2',
           ' ',
           'enquiry_list.png',
           1,
           'Modular Course Application List',
           NULL,
           NULL)
END;

IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Login E-mail'
      AND [menu_ParentId] = 1
      AND [menu_ToPage] = '/Mail_Trigger.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu] 
           ([menu_Name], [menu_dtTime], [menu_ParentId], [menu_ToPage], [menu_ImageName], 
            [menu_color], [menu_description], [menu_SImage], [menu_DisplayOrder], 
            [menu_tooltip], [menu_AndroidImage], [LeftPannelMenuForAndroit])
    VALUES 
           ('Login E-mail', GETDATE(), 1, '/Mail_Trigger.aspx', 'StudentPromotion.png', 
            '#6885a2', ' ', 'report_status.png', 8, 'Mail_Trigger', NULL, NULL)
END;


IF NOT EXISTS (
    SELECT 1 FROM [dbo].[tbl_Menu]
    WHERE [menu_Name] = 'Attendance Monthwise Report'
      AND [menu_ParentId] = 2446
      AND [menu_ToPage] = '/AttendanceMonthWiseReport.aspx'
)
BEGIN
    INSERT INTO [dbo].[tbl_Menu]
           ([menu_Name]
           ,[menu_dtTime]
           ,[menu_ParentId]
           ,[menu_ToPage]
           ,[menu_ImageName]
           ,[menu_color]
           ,[menu_description]
           ,[menu_SImage]
           ,[menu_DisplayOrder]
           ,[menu_tooltip]
           ,[menu_AndroidImage]
           ,[LeftPannelMenuForAndroit])
     VALUES
           ('Attendance Monthwise Report',
           GETDATE(),
           2446,
           '/AttendanceMonthWiseReport.aspx',
           'report_status.png',
           '#6885a2',
           ' ',
           'TimeTableIcon.png',
           13,
           'Report',
           NULL,
           NULL)
END;
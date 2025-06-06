IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_get_Commission_Employee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_get_Commission_Employee]
        (
            @EmpORAgent_Status bigint
        )
        AS
        BEGIN
            IF (@EmpORAgent_Status = 2)
            BEGIN
                SELECT DISTINCT 
                    [Commission_Setting_Id],
                    [Candidate_Fname] + '' '' + [Candidate_Mname] + '' '' + [Candidate_Lname] AS Student_name,
                    [Tbl_Fee_Settings].[Fee_Code] AS Feecode,
                    Fee_Head_Name,
                    [Commission_Amount],
                    [Agent_Name] AS Name,
                    balance,
                    [EmpORAgent_Status]
                FROM 
                    Tbl_Commission_Settings
                INNER JOIN 
                    [dbo].[Tbl_Candidate_Personal_Det] ON Tbl_Commission_Settings.[Agent_ID] = [Tbl_Candidate_Personal_Det].[Agent_ID]
                INNER JOIN 
                    [dbo].[Tbl_Agent] ON [dbo].[Tbl_Agent].[Agent_ID] = Tbl_Candidate_Personal_Det.[Agent_ID]
                INNER JOIN 
                    [dbo].[Tbl_Fee_Settings] ON [dbo].[Tbl_Commission_Settings].fee_code_id = [dbo].[Tbl_Fee_Settings].[Fee_Settings_Id]
                INNER JOIN 
                    [Tbl_Fee_Entry_Main] ON [Tbl_Fee_Entry_Main].Candidate_Id = [Tbl_Candidate_Personal_Det].[Candidate_Id]
                    AND Tbl_Fee_Entry_Main.Commision_Settings_Id = Tbl_Commission_Settings.[Commission_Setting_Id]
                    AND [Tbl_Commission_Settings].ItemDescription = [Tbl_Fee_Entry_Main].ItemDescription
                INNER JOIN 
                    [dbo].[Tbl_Fee_Head] ON [Tbl_Commission_Settings].Feehead_Id = [dbo].[Tbl_Fee_Head].Fee_Head_Id
                WHERE 
                    balance = 0
            END

            IF (@EmpORAgent_Status = 1)
            BEGIN
                SELECT DISTINCT 
                    [Commission_Setting_Id],
                    [Candidate_Fname] + '' '' + [Candidate_Mname] + '' '' + [Candidate_Lname] AS Student_name,
                    [Tbl_Fee_Settings].[Fee_Code] AS Feecode,
                    Fee_Head_Name,
                    [Commission_Amount],
                    Employee_FName + '' '' + [Employee_LName] AS Name,
                    balance,
                    [EmpORAgent_Status]
                FROM 
                    Tbl_Commission_Settings
                INNER JOIN 
                    [dbo].[Tbl_Candidate_Personal_Det] ON Tbl_Commission_Settings.Employee_Id = [Tbl_Candidate_Personal_Det].[CounselorEmployee_id]
                INNER JOIN 
                    Tbl_Employee ON Tbl_Employee.Employee_Id = [Tbl_Candidate_Personal_Det].[CounselorEmployee_id]
                INNER JOIN 
                    [dbo].[Tbl_Fee_Settings] ON [dbo].[Tbl_Commission_Settings].fee_code_id = [dbo].[Tbl_Fee_Settings].[Fee_Settings_Id]
                INNER JOIN 
                    [Tbl_Fee_Entry_Main] ON [Tbl_Fee_Entry_Main].Candidate_Id = [Tbl_Candidate_Personal_Det].[Candidate_Id]
                    AND Tbl_Fee_Entry_Main.Commision_Settings_Id = Tbl_Commission_Settings.[Commission_Setting_Id]
                    AND [Tbl_Commission_Settings].ItemDescription = [Tbl_Fee_Entry_Main].ItemDescription
                INNER JOIN 
                    [dbo].[Tbl_Fee_Head] ON [Tbl_Commission_Settings].Feehead_Id = [dbo].[Tbl_Fee_Head].Fee_Head_Id
                WHERE 
                    balance = 0
            END
        END
    ')
END

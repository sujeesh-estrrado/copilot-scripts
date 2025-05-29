IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetManpower_Request_DetailsById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetManpower_Request_DetailsById]
(
    @ID BIGINT
)
AS
BEGIN
    SELECT
        M.[ID],
        M.[Document_No],
        M.[Create_date],
        M.[Revision_no],
        M.[Date_Of_Submission],
        M.[Department_Id],
        M.[Prepared_By],
        M.[Job_Description_Doc],
        M.[Job_Description_Doc_Path],
        M.[Position_Id],
        M.[Recrutment_Type],
        M.[Current_No_Of_Staff],
        M.[No_Of_Staff_Req],
        M.[Expected_Teach_Load],
        ISNULL(M.[Other_Reason_For_Requisition], '''') AS Other_Reason_For_Requisition,
        M.[Expected_Close_Date_Of_Recruitment],
        M.[Closing_Date],
        M.[Status_Of_Employeement],
        M.[Contract_Duration],
        M.[Temporary_Duration],
        M.[Position_Type],
        M.[Relevent_Experience_Requirement],
        M.[Any_Other_Specific_Requirement],
        M.[Recommendation_By_DVC_Academic_Affairs],
        M.[Endorsement_By_ViceChancellor],
        M.[Recommendation_By_Group_Senior_Director],
        M.[Final_Approval_By_ManagingDirector],
        M.[No_Of_Applications],
        M.[Number_Of_Hiring],
        M.[Hiring_Date],
        M.[AdditionWorkLoad],
        M.[BusinessUnitGrowth],
        M.[ReStructuring],
        M.[Seperation],
        M.[OtherReason],
        M.[PleaseSpecify],
        M.[Doctorate],
        M.[Master],
        M.[Bachelor],
        M.[AdvDiploma],
        M.[Certificate],
        M.[STPM],
        M.[NoFormalEducationNeeded],
        M.[SPM],
        ISNULL(E.[Employee_FName] + '' '' + E.[Employee_LName], '''') AS EmployeeName
    FROM [dbo].[Tbl_Manpower_Request_Details] M
    LEFT JOIN dbo.Tbl_User U ON U.[user_Id] = M.[Prepared_By]
    LEFT JOIN Tbl_Employee_User EU ON EU.[User_Id] = U.[user_Id]
    LEFT JOIN [dbo].[Tbl_Employee] E ON E.[Employee_Id] = EU.Employee_Id
    WHERE M.[ID] = @ID
END
');
END;
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertManpower_Request_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_InsertManpower_Request_Details]       
 @ID bigint=1,      
 @Document_No varchar(100)='''',      
 @Revision_no bigint=0,      
 @Department_Id bigint=0,      
 @Job_Description_Doc varchar(50)='''',
 @Position_Id bigint=0,      
 @Recrutment_Type varchar(100)='''',      
 @Current_No_Of_Staff bigint=0,      
 @No_Of_Staff_Req bigint=0,      
 @Expected_Teach_Load decimal(14,2)=0.00,      
 @Other_Reason_For_Requisition varchar(max)='''',      
 @Expected_Close_Date_Of_Recruitment bigint=0,      
 @Closing_Date bigint=0,      
 @Status_Of_Employeement varchar(100)='''',      
 @Contract_Duration bigint=0,      
 @Temporary_Duration bigint=0,      
 @Position_Type varchar(100)='''',      
 @Relevent_Experience_Requirement varchar(100)='''',      
 @Any_Other_Specific_Requirement varchar(100)='''',      
 @Recommendation_By_DVC_Academic_Affairs varchar(100)='''',      
 @Endorsement_By_ViceChancellor varchar(100)='''',      
 @Recommendation_By_Group_Senior_Director varchar(100)='''',      
 @Final_Approval_By_ManagingDirector varchar(100)='''',      
 @No_Of_Applications bigint=0,      
 @Number_Of_Hiring bigint=0,      
 @Hiring_Date datetime=''02/24/2020'',      
 @AdditionWorkLoad bit=0,      
 @BusinessUnitGrowth bit=0,      
 @ReStructuring bit=0,      
 @Seperation bit=0,      
 @OtherReason bit=0,      
 @PleaseSpecify varchar(max)='''',      
 @Doctorate bit=0,      
 @Master bit=0,      
 @Bachelor bit=0,      
 @AdvDiploma bit=0,      
 @Certificate bit=0,      
 @STPM bit=0,      
 @NoFormalEducationNeeded bit=0,      
 @Prepared_By bigint=0,      
 @SPM bit=0,
 @Job_Description_Doc_Path varchar(50)=''''
AS      
BEGIN      
 IF(@ID>0)      
  BEGIN      
   UPDATE       
    [dbo].[Tbl_Manpower_Request_Details]      
   SET      
    [Date_Of_Submission]=GETDATE(),[Revision_no]=@Revision_no,[Department_Id]=@Department_Id,      
    [Job_Description_Doc]=@Job_Description_Doc,[Position_Id]=@Position_Id,[Recrutment_Type]=@Recrutment_Type,      
    [Current_No_Of_Staff]=@Current_No_Of_Staff,[No_Of_Staff_Req]=@No_Of_Staff_Req,[Expected_Teach_Load]=@Expected_Teach_Load,      
    [Other_Reason_For_Requisition]=@Other_Reason_For_Requisition,[Expected_Close_Date_Of_Recruitment]=@Expected_Close_Date_Of_Recruitment,      
    [Closing_Date]=@Closing_Date,[Status_Of_Employeement]=@Status_Of_Employeement,[Contract_Duration]=@Contract_Duration,      
    [Temporary_Duration]=@Temporary_Duration,[Position_Type]=@Position_Type,[Relevent_Experience_Requirement]=@Relevent_Experience_Requirement,      
    [Any_Other_Specific_Requirement]=@Any_Other_Specific_Requirement,[Recommendation_By_DVC_Academic_Affairs]=@Recommendation_By_DVC_Academic_Affairs,      
    [Endorsement_By_ViceChancellor]=@Endorsement_By_ViceChancellor,[Recommendation_By_Group_Senior_Director]=@Recommendation_By_Group_Senior_Director,      
    [Final_Approval_By_ManagingDirector]=@Final_Approval_By_ManagingDirector,[No_Of_Applications]=@No_Of_Applications,      
    [Number_Of_Hiring]=@Number_Of_Hiring,[Hiring_Date]=@Hiring_Date,[AdditionWorkLoad]=@AdditionWorkLoad,      
    [BusinessUnitGrowth]=@BusinessUnitGrowth,[ReStructuring]=@ReStructuring,[Seperation]=@Seperation,      
    [OtherReason]=@OtherReason,[PleaseSpecify]=@PleaseSpecify,[Doctorate]=@Doctorate,[Master]=@Master,[Bachelor]=@Bachelor,[AdvDiploma]=@AdvDiploma,      
    [Certificate]=@Certificate,[STPM]=@STPM,[NoFormalEducationNeeded]=@NoFormalEducationNeeded,[SPM]=@SPM,[Job_Description_Doc_Path]= @Job_Description_Doc_Path      
   WHERE      
    [ID]=@ID      
  END      
 ELSE      
  BEGIN      
   INSERT INTO [dbo].[Tbl_Manpower_Request_Details]      
   ([Document_No],[Create_date],[Revision_no],[Date_Of_Submission],[Department_Id],[Prepared_By],      
   [Job_Description_Doc],[Position_Id],[Recrutment_Type],[Current_No_Of_Staff],[No_Of_Staff_Req],      
   [Expected_Teach_Load],[Other_Reason_For_Requisition],[Expected_Close_Date_Of_Recruitment],[Closing_Date],      
   [Status_Of_Employeement],[Contract_Duration],[Temporary_Duration],[Position_Type],[Relevent_Experience_Requirement],      
   [Any_Other_Specific_Requirement],[Recommendation_By_DVC_Academic_Affairs],[Endorsement_By_ViceChancellor],      
   [Recommendation_By_Group_Senior_Director],[Final_Approval_By_ManagingDirector],[No_Of_Applications],[Number_Of_Hiring],      
   [Hiring_Date],[AdditionWorkLoad],[BusinessUnitGrowth],[ReStructuring],[Seperation],[OtherReason],[PleaseSpecify],      
   [Doctorate],[Master],[Bachelor],[AdvDiploma],[Certificate],[STPM],[NoFormalEducationNeeded],[SPM],[DelStatus],[Job_Description_Doc_Path])      
   VALUES      
   (@Document_No,GETDATE(),0,GETDATE(),@Department_Id,@Prepared_By,@Job_Description_Doc,@Position_Id,@Recrutment_Type,      
   @Current_No_Of_Staff,@No_Of_Staff_Req,@Expected_Teach_Load,@Other_Reason_For_Requisition,@Expected_Close_Date_Of_Recruitment,@Closing_Date,      
   @Status_Of_Employeement,@Contract_Duration,@Temporary_Duration,@Position_Type,@Relevent_Experience_Requirement,      
   @Any_Other_Specific_Requirement,@Recommendation_By_DVC_Academic_Affairs,@Endorsement_By_ViceChancellor,      
   @Recommendation_By_Group_Senior_Director,@Final_Approval_By_ManagingDirector,@No_Of_Applications,@Number_Of_Hiring,@Hiring_Date,      
   @AdditionWorkLoad,@BusinessUnitGrowth,@ReStructuring,@Seperation,@OtherReason,@PleaseSpecify,      
   @Doctorate,@Master,@Bachelor,@AdvDiploma,@Certificate,@STPM,@NoFormalEducationNeeded,@SPM,0,@Job_Description_Doc_Path)      
  END      
END
    ');
END;

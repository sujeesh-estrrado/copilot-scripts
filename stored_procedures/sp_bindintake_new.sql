IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_bindintake_new]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_bindintake_new]
    -- Add the parameters for the stored procedure here
    @CandidateId bigint=0,
    @Choice bigint=0
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@Choice=1)
    begin

        select na.New_Admission_Id
        , CONCAT(na.Department_Id,''#'',na.Batch_Id) Choice
        ,im.intake_year,im.intake_month,im.Study_Mode,na.Course_Category_Id,im.id IntakeId
         from Tbl_Candidate_Personal_Det cpd 
        left join tbl_New_Admission na on na.new_admission_id=cpd.new_admission_id

        left join Tbl_Course_Batch_Duration cbd1 on cbd1.batch_id=na.batch_id
        left join tbl_intakemaster im on im.id= cbd1.intakemasterid
        where cpd.candidate_id=@CandidateId
    end

    if(@Choice=2)
    begin

        select na.New_Admission_Id
        , CONCAT(na.Department_Id,''#'',na.Batch_Id) Choice
        ,im.intake_year,im.intake_month,im.Study_Mode,na.Course_Category_Id
         from Tbl_Candidate_Personal_Det cpd 
        left join tbl_New_Admission na on na.new_admission_id=cpd.Option2

        left join Tbl_Course_Batch_Duration cbd1 on cbd1.batch_id=na.batch_id
        left join tbl_intakemaster im on im.id= cbd1.intakemasterid
        where cpd.candidate_id=@CandidateId
    end

    if(@Choice=3)
    begin

        select na.New_Admission_Id
        , CONCAT(na.Department_Id,''#'',na.Batch_Id) Choice
        ,im.intake_year,im.intake_month,im.Study_Mode,na.Course_Category_Id
         from Tbl_Candidate_Personal_Det cpd 
        left join tbl_New_Admission na on na.new_admission_id=cpd.Option3

        left join Tbl_Course_Batch_Duration cbd1 on cbd1.batch_id=na.batch_id
        left join tbl_intakemaster im on im.id= cbd1.intakemasterid
        where cpd.candidate_id=@CandidateId
    end
END
    ')
END

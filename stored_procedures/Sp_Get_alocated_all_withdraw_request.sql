IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_alocated_all_withdraw_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Get_alocated_all_withdraw_request](@Type varchar(max),@Employee_id bigint)
As
begin

select concat(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname) as Candidate_Name,CPD.adharnumber as icno,CPD.idmatrixno as matrixnno,
ST.Request_status as Status,CC.Candidate_Email,CPD.Candidate_Id as ID,CL.Course_Level_Name,ST.Create_date as date,ST.Remark as Student_remark from Tbl_Candidate_Personal_Det CPD inner join Tbl_Student_Tc_request ST on ST.Candidate_id=
CPD.Candidate_Id
inner join Tbl_Course_Level CL on CL.Course_Level_Id=ST.Faculty_id
inner join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=CPD.Candidate_Id
where CPD.Candidate_DelStatus=0 and ST.Request_type=@Type and ST.Counselor_id=@Employee_id  and (ST.Counselling_Status=0 or ST.Counselling_Status is null) and ST.Delete_status=0;
end
    ')
END

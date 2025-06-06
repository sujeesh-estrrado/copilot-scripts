IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Candidate_Offerletter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Candidate_Offerletter]  
(
@Candidate_Id bigint,@flag bigint=0
)          
AS            
BEGIN 
   if(@flag=0)
select O.candidate_id,Offerletter_Path,A.Offerletter_status,o.Sented_by,
SUBSTRING( Offerletter_Path , LEN(Offerletter_Path) -  CHARINDEX(''//'',REVERSE(Offerletter_Path))+2  , LEN(Offerletter_Path)) as Title
  from Tbl_Offerlettre  O
left join  tbl_approval_log A on O.candidate_id=A.candidate_id
   where O.candidate_id=@Candidate_Id and O.delete_status=0 and    A.delete_status=0 

if(@flag=1)
begin
----SELECT 
--    --    COUNT(*) AS OfferLetterCount
--    --FROM 
--    --    Tbl_Offerlettre
--    --WHERE 
--    --    candidate_id = @Candidate_Id 
--    --    AND delete_status = 0;
    select * from Tbl_NotificationNew  N join Tbl_Student_User T 
    on N.User_Id =T.User_Id 
    where T.Candidate_Id=@Candidate_Id and Category_id=3  and IsRead_Status=0

END

if(@flag=2)
begin

    UPDATE Tbl_NotificationNew 
SET IsRead_Status = 1 
WHERE User_Id IN (
    SELECT User_Id 
    FROM Tbl_Student_User 
    WHERE Candidate_Id = @Candidate_Id
)

END
    



end
    ')
END

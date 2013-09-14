classdef DateFun

     methods (Static)
     
         function [year] = getYear(dateasNum) 
         
             year =  floor(dateasNum/10000);
             
         end
         
             function [mth] = getMonth(dateasNum) 
         
             mth =   mod((dateasNum - mod(dateasNum,100))/100,100);
             
             end 
             
         function [day] = getDay(dateasNum) 
         
             day =   mod(dateasNum,100);
             
         end 
         
         function [dateasNum] = getDateasNum(yyyy,mm,dd) 
         
             dateasNum = 10000*yyyy+100*mm+dd;
             
         end 
         
          function [returnDate] = getBOM(dateasnum) 
         
              returnDate = DateFun.getDateasNum(DateFun.getYear(dateasnum),DateFun.getMonth(dateasnum),1);
             
         end 
        
       function [qend] = getEOM(dateasNum) 
             yyyy = DateFun.getYear(dateasNum);
             mm = DateFun.getMonth(dateasNum);
            
             endd = eomday(yyyy, mm);
             qend = DateFun.getDateasNum(yyyy,mm,endd);
             
          end  
         
          function [qend] = getQEnd(dateasNum) 
             yyyy = DateFun.getYear(dateasNum);
             mm = DateFun.getMonth(dateasNum);
             qendm =  mm + 2-mod(mm+2,3);
             qendd = eomday(yyyy, qendm);
             qend = DateFun.getDateasNum(yyyy,qendm,qendd);
             
          end 
          
          function [newdate] = addMonths(dateasNum,mths_count)
          initialdate = datenum(num2str(dateasNum),'yyyymmdd');
          futuredate = addtodate(initialdate,mths_count,'month');
           newdate = str2num(datestr(futuredate, 'yyyymmdd'));
          end
          
          function [newdate] = addYears(dateasNum,yrs_count)
          initialdate = datenum(num2str(dateasNum),'yyyymmdd');
          futuredate = addtodate(initialdate,yrs_count,'year');
           newdate = str2num(datestr(futuredate, 'yyyymmdd'));
          end
          
          
          function [newdate] = matlabDate(dateasNum)
          newdate = datenum(num2str(dateasNum),'yyyymmdd');
          end
          
          function [newdate] = DKSuperDate(dateasNum)
          newdate = str2num(datestr(dateasNum,'yyyymmdd'));
          end
         
          
         function [datediff] = datediffdays(dateasNum_1,dateasNum_2)
         date_1 = DateFun.matlabDate(dateasNum_1);
         date_2 = DateFun.matlabDate(dateasNum_2);
         datediff = date_2-date_1;
         end
          
             
          %function [qend] = getDay(yyyy,mm,dd) 
          %   qendm =  mm + 2-mod(mm+2,3);
          %   qendd = eomday(yyyy, qendm)
          %end 
         
          
         
     end
     
end

from mrjob.job import MRJob
import calendar

class Weather(MRJob):

    def mapper(self, key, line):
        yield(calendar.month_name[int(line.split()[1][4:6])]+'_temp_max',float(line.split()[5]))
        yield(calendar.month_name[int(line.split()[1][4:6])]+'_temp_min',float(line.split()[6]))
    
    def reducer(self,key, temp):
        yield(key,max(temp) if 'temp_max' in key else min(temp))

if __name__ == '__main__':
    Weather.run()

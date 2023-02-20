from mrjob.job import MRJob

class temp(MRJob):

	def mapper(self,_,line):
		yield('temp_min',float(line.split()[6]))
		yield('temp_max',float(line.split()[5]))


	def reducer(self,key,temp):
		yield(key,max(temp) if key == 'temp_max' else min(temp))


if __name__ =='__main__':
	temp.run()



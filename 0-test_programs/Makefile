
all: add add_unified_shared_mem

add: add.cu
	nvcc add.cu -o add

add_unified_shared_mem: add_unified_shared_mem.cu
	nvcc add_unified_shared_mem.cu -o add_unified_shared_mem

clean: 
	rm add
	rm add_unified_shared_mem
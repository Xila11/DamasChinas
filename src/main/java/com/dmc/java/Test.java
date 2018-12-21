/*package com.dmc.java;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.function.Function;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.LongStream;
import java.util.stream.Stream;

public class Test {

	Runnable r1 = () -> System.out.println(this);
	Runnable r2 = () -> System.out.println(toString());

	public String toString() {
		return super.toString() + " Hello, world!";
	}

	public static void main(String... args) throws IOException {
		new Test().r1.run(); // Hello, world!
		new Test().r2.run(); // Hello, world!
		
		Function<String, String> atr = (name) -> {return "@" + name;};
		System.out.println(atr.apply("Dilan"));
		
		 Files.list(Paths.get("../"))
		     .map(Path::getFileName) // still a path
		     .map(Path::toString) // convert to Strings
		     .filter(name -> name.endsWith(".*"))
		     .sorted() // sort them alphabetically
		     .limit(5) // first 5	
		     .forEach(System.out::println);
	}
}


@FunctionalInterface
interface Oracle{
	
	public static<T> Stream<T> of(T... values) {
		    return Arrays.stream(values);
		 }
	
	void get();
	
	default void run(){
		System.out.println("Testing");
	}
}

@FunctionalInterface
interface Softtek{
	
	void get();
	
	default void run(){
		System.out.println("Testing");
	}
}


class OracleImp implements Oracle,Softtek
{

	@Override
	public void get() {
		// TODO Auto-generated method stub
		
	}
	
    public void run(){
    	
	}
}*/
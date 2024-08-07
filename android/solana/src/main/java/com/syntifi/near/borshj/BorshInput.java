package com.syntifi.near.borshj;


import com.syntifi.near.borshj.annotation.BorshSubTypes;
import com.syntifi.near.borshj.exception.BorshException;
import com.syntifi.near.borshj.util.BorshUtil;

import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Optional;
import java.util.SortedSet;

import static java.util.Objects.requireNonNull;

/**
 * Interface with default implementations for input bytes/reading data
 *
 * @author Alexandre Carvalho
 * @author Andre Bertolace
 * @since 0.1.0
 */
public interface BorshInput {

    /**
     * Reads from buffer to specified type of clazz
     *
     * @param clazz the type to read data to
     * @param <T>   type of clazz parameter
     * @return the data mapped to the type of T
     */
    @SuppressWarnings("unchecked")
    default <T> T read(final Class<T> clazz) {
        requireNonNull(clazz);
        if (clazz == Byte.class || clazz == byte.class) {
            return (T) Byte.valueOf(this.readU8());
        } else if (clazz == Short.class || clazz == short.class) {
            return (T) Short.valueOf(this.readU16());
        } else if (clazz == Integer.class || clazz == int.class) {
            return (T) Integer.valueOf(this.readU32());
        } else if (clazz == Long.class || clazz == long.class) {
            return (T) Long.valueOf(this.readU64());
        } else if (clazz == Float.class || clazz == float.class) {
            return (T) Float.valueOf(this.readF32());
        } else if (clazz == Double.class || clazz == double.class) {
            return (T) Double.valueOf(this.readF64());
        } else if (clazz == Boolean.class || clazz == boolean.class) {
            return (T) Boolean.valueOf(this.readBoolean());
        } else if (clazz == BigInteger.class) {
            return (T) this.readU128();
        } else if (clazz == String.class) {
            return (T) this.readString();
        } else if (clazz == Optional.class) {
            return (T) this.readOptional();
        } else if (clazz.isInterface()) {
            return (T) this.readSubType(clazz);
        } else if (clazz.isEnum()) {
            return this.readEnum(clazz);
        } else if (Borsh.class.isAssignableFrom(clazz)) {
            return this.readPOJO(clazz);
        }
        throw new IllegalArgumentException();
    }

    /**
     * Reads a value for a Generic type
     *
     * @param clazz          the generic class
     * @param parameterClass clazz parameter class
     * @param <T>            object class type
     * @param <P>            parameter class type
     * @return the data mapped to the type of Generic of T.
     */
    @SuppressWarnings("unchecked")
    default <T, P> T read(final Class<T> clazz, final Class<P> parameterClass) {
        requireNonNull(clazz);
        requireNonNull(parameterClass);
        if (clazz == Optional.class) {
            return (T) this.readOptional(parameterClass);
        } else if (Collection.class.isAssignableFrom(clazz)) {
            return (T) this.readGenericArray(parameterClass);
        }
        throw new IllegalArgumentException();
    }

    /**
     * Reads a value for a key/value type
     *
     * @param clazz           the key/value type class object
     * @param parameterClassK the parameter class object of key type
     * @param parameterClassV the parameter class object of value type
     * @param <T>             the type of key/value class object
     * @param <K>             the type of key parameter
     * @param <V>             the type of value parameter
     * @return the map object with its data
     */
    @SuppressWarnings("unchecked")
    default <T, K, V> T read(final Class<T> clazz, final Class<K> parameterClassK, final Class<V> parameterClassV) {
        requireNonNull(clazz);
        requireNonNull(parameterClassK);
        requireNonNull(parameterClassV);
        if (Map.class.isAssignableFrom(clazz)) {
            return (T) this.readGenericMap(parameterClassK, parameterClassV);
        }
        throw new IllegalArgumentException();
    }

    /**
     * Read Enum by its ordinal byte
     *
     * @param clazz Enum class
     * @param <T> the type parameter
     * @return the enum resulting of read ordinal
     */
    default <T> T readEnum(Class<T> clazz) {
        int ordinal = this.readU8();
        return clazz.getEnumConstants()[ordinal];
    }

    /**
     * Reads into a Borsh POJO
     *
     * @param clazz Borsh POJO class
     * @param <T>   type of Borsh POJO class
     * @return Borsh POJO instance with its data
     */
    default <T> T readPOJO(final Class<T> clazz) {
        try {
            final T object = clazz.getConstructor().newInstance();
            SortedSet<Field> fields = BorshUtil.filterAndSort(BorshUtil.getAllFields(object.getClass()));
            for (final Field field : fields) {
                field.setAccessible(true);
                final Class<?> fieldClass = field.getType();
                // Is generic type?
                if (fieldClass.getTypeParameters().length == 1) {
                    final Type fieldType = field.getGenericType();
                    if (!(fieldType instanceof ParameterizedType)) {
                        throw new AssertionError("unsupported Generic type");
                    }
                    final Type[] typeArgs = ((ParameterizedType) fieldType).getActualTypeArguments();
                    assert (typeArgs.length == 1);
                    final Class<?> parameterClass = (Class<?>) typeArgs[0];
                    field.set(object, this.read(fieldClass, parameterClass));
                } else if (fieldClass.getTypeParameters().length == 2) {
                    final Type fieldType = field.getGenericType();
                    if (!(fieldType instanceof ParameterizedType)) {
                        throw new AssertionError("unsupported Generic type");
                    }
                    final Type[] typeArgs = ((ParameterizedType) fieldType).getActualTypeArguments();
                    assert (typeArgs.length == 2);
                    final Class<?> parameterClassK = (Class<?>) typeArgs[0];
                    final Class<?> parameterClassV = (Class<?>) typeArgs[1];
                    field.set(object, this.read(fieldClass, parameterClassK, parameterClassV));
                } else if (fieldClass == byte[].class) {
                    field.set(object, this.readFixedArray(Array.getLength(field.get(object))));
                } else {
                    field.set(object, this.read(field.getType()));
                }
            }
            return object;
        } catch (NoSuchMethodException | InstantiationException | IllegalAccessException
                | InvocationTargetException error) {
            throw new BorshException(error);
        }
    }

    /**
     * Reads a target object which inherits from given interface
     *
     * @param clazz the interface which should hold subtype mapping
     * @param <T>   type of interface
     * @return the subtype data read
     */
    default <T> Object readSubType(Class<T> clazz) {
        if (BorshUtil.hasAnnotation(clazz, BorshSubTypes.class)) {
            BorshSubTypes borshSubTypes = BorshUtil.findAnnotation(clazz, BorshSubTypes.class);
            // read the ordinal which defines target class
            int ordinal = this.readU8();
            // finds the subtype for the given ordinal
            Optional<BorshSubTypes.BorshSubType> useSubType = Arrays.stream(borshSubTypes.value()).filter(t -> t.when() == ordinal).findFirst();
            if (useSubType.isPresent()) {
                // read data to target subtype
                return this.read(useSubType.get().use());
            } else {
                throw new BorshException(String.format("No subtype with ordinal %s for interface %s", ordinal, clazz.getSimpleName()));
            }
        } else {
            throw new BorshException(String.format("Interface %s must have @BorshSubTypes annotation for subtype mapping.", clazz.getSimpleName()));
        }
    }

    /**
     * Read data as U8
     *
     * @return U8 as byte
     */
    default byte readU8() {
        return this.read();
    }

    /**
     * Read data as U16
     *
     * @return U16 as short
     */
    default short readU16() {
        return BorshBuffer.wrap(this.read(2)).readU16();
    }

    /**
     * Read data as U32
     *
     * @return U32 as int
     */
    default int readU32() {
        return BorshBuffer.wrap(this.read(4)).readU32();
    }

    /**
     * Read data as U64
     *
     * @return U64 as long
     */
    default long readU64() {
        return BorshBuffer.wrap(this.read(8)).readU64();
    }

    /**
     * Read data as U128
     *
     * @return U128 as BigInteger
     */
   
    default BigInteger readU128() {
        final byte[] bytes = new byte[16];
        this.read(bytes);
        for (int i = 0; i < 8; i++) {
            final byte a = bytes[i];
            final byte b = bytes[15 - i];
            bytes[i] = b;
            bytes[15 - i] = a;
        }
        return new BigInteger(bytes);
    }

    /**
     * Read data as F32
     *
     * @return F32 as float
     */
    default float readF32() {
        return BorshBuffer.wrap(this.read(4)).readF32();
    }

    /**
     * Read data as F64
     *
     * @return F64 as double
     */
    default double readF64() {
        return BorshBuffer.wrap(this.read(8)).readF64();
    }

    /**
     * Read data as String
     *
     * @return the String
     */
   
    default String readString() {
        final int length = this.readU32();
        final byte[] bytes = new byte[length];
        this.read(bytes);
        return new String(bytes, StandardCharsets.UTF_8);
    }

    /**
     * Read data as FixedArray
     *
     * @param length the length of the array
     * @return data as byte[]
     */
   
    default byte[] readFixedArray(final int length) {
        if (length < 0) {
            throw new IllegalArgumentException();
        }
        final byte[] bytes = new byte[length];
        this.read(bytes);
        return bytes;
    }

    /**
     * Reads array to array of T
     *
     * @param clazz class of array items
     * @param <T>   type of class
     * @return the array of T with its elements read
     */
    @SuppressWarnings("unchecked")
   
    default <T> T[] readArray(final Class<T> clazz) {
        final int length = this.readU32();
        final T[] elements = (T[]) Array.newInstance(clazz, length);
        for (int i = 0; i < length; i++) {
            elements[i] = this.read(clazz);
        }
        return elements;
    }

    /**
     * Reads a Generic Array
     *
     * @param parameterClass the parametrization class
     * @param <T>            the type of parameterClass
     * @return the collection with items of type T with its data read
     */
   
    default <T> Collection<T> readGenericArray(final Class<T> parameterClass) {
        final int length = this.readU32();
        Collection<T> elements;
        elements = new ArrayList<>();
        for (int i = 0; i < length; i++) {
            elements.add(this.read(parameterClass));
        }
        return elements;
    }

    /**
     * Reads a Map
     *
     * @param parameterClassK the class type of key parameter
     * @param parameterClassV the class type of value parameter
     * @param <K>             key parameter class
     * @param <V>             value parameter class
     * @return the map object with its data
     */
   
    default <K, V> Map<K, V> readGenericMap(final Class<K> parameterClassK, final Class<V> parameterClassV) {
        final int length = this.readU32();
        Map<K, V> elements;
        elements = new HashMap<>();
        for (int i = 0; i < length; i++) {
            elements.put(this.read(parameterClassK), this.read(parameterClassV));
        }
        return elements;
    }

    /**
     * Reads a boolean
     *
     * @return the boolean
     */
    default boolean readBoolean() {
        return (this.readU8() != 0);
    }

    /**
     * Reads an optional
     *
     * @param <T> type of optional data
     * @return the Optional object
     */
   
    default <T> Optional<T> readOptional() {
        final boolean isPresent = (this.readU8() != 0);
        if (!isPresent) {
            return Optional.empty();
        }
        throw new AssertionError("Optional type has been erased and cannot be reconstructed");
    }

    /**
     * Reads an optional
     *
     * @param clazz parameter class of optional
     * @param <T>   the type of the parameter class
     * @return the optional with its value read
     */
   
    default <T> Optional<T> readOptional(final Class<T> clazz) {
        final boolean isPresent = (this.readU8() != 0);
        return isPresent ? Optional.of(this.read(clazz)) : Optional.empty();
    }

    /**
     * Reads a byte
     *
     * @return the byte read
     */
    byte read();

    /**
     * Reads a byte array
     *
     * @param length the length of the array
     * @return the read byte array
     */
    default byte[] read(final int length) {
        if (length < 0) {
            throw new IllegalArgumentException();
        }
        final byte[] result = new byte[length];
        this.read(result);
        return result;
    }

    /**
     * Reads byte array into result
     *
     * @param result the byte array to read into
     */
    default void read(final byte[] result) {
        this.read(result, 0, result.length);
    }

    /**
     * Reads byte array into result
     *
     * @param result the byte array to read into
     * @param offset the offset to skip
     * @param length the length to read
     */
    void read(byte[] result, int offset, int length);
}
